
// ============================================================================
// Lifetime
// ============================================================================

function fmod_studio_system_create(): FMOD.StudioSystem
{
    fmod.Studio_System_Create(out);
    return out.val;
}

function fmod_studio_system_initialize(
    studio: FMOD.StudioSystem, 
    maxchannels: number, 
    studioflags: FMOD.STUDIO_INITFLAGS, 
    coreflags: FMOD.INITFLAGS): void
{
    // Core optimiazations
    check = studio.getCoreSystem(out);
    CHECK_RESULT(check);
    var gSystem = out.val;

    check = gSystem.getDriverInfo(0, null, null, out, null, null);
    CHECK_RESULT(check);
    check = gSystem.setSoftwareFormat(out.val, FMOD.SPEAKERMODE.DEFAULT, 0);
    CHECK_RESULT(check);

    check = gSystem.setDSPBufferSize(2048, 2);
    CHECK_RESULT(check);

    // Initialize studio
    check = studio.initialize(maxchannels, studioflags, coreflags, null);
    if (check == FMOD.RESULT.OK)
        gStudio = studio;
}

function fmod_studio_system_release(studio: FMOD.StudioSystem): void
{
    check = studio.release();
}


// ============================================================================
// Update
// ============================================================================

function fmod_studio_system_update(studio: FMOD.StudioSystem): void
{
    check = studio.update();
}

function fmod_studio_system_flush_commands(studio: FMOD.StudioSystem): void
{
    check = studio.flushCommands();
}

function fmod_studio_system_flush_sample_loading(studio: FMOD.StudioSystem): void
{
    check = studio.flushSampleLoading();
}


// ============================================================================
// Banks
// ============================================================================

function fmod_studio_system_load_bank_file(studio: FMOD.StudioSystem,
    filename: string,
    flags: FMOD.STUDIO_LOAD_BANK_FLAGS): FMOD.Bank
{
    check = studio.loadBankFile(filename, flags, out);
    CHECK_RESULT(check);
    return out.val as FMOD.Bank;
}

function fmod_studio_system_unload_all(studio: FMOD.StudioSystem)
{
    studio.unloadAll();
}

function fmod_studio_system_get_bank(studio: FMOD.StudioSystem, 
    bankpath: string): FMOD.Bank
{
    studio.getBank(bankpath, out);

    return out.val;
}

function fmod_studio_system_get_bank_by_id(studio: FMOD.StudioSystem,
    gmbuffer: ArrayBuffer): FMOD.Bank
{
    let bank: FMOD.Bank = null;

    if (studio.isValid())
    {
        let guid: FMOD.GUID = fmod.GUID();
        let buf = new GMBuffer(gmbuffer);

        guid.Data1 = buf.readUint32();
        guid.Data2 = buf.readUint16();
        guid.Data3 = buf.readUint16();
        
        for (let i = 0; i < 8; ++i)
        {
            guid.Data4[i] = buf.readUint8();
        }

        check = studio.getBankByID(guid, out);
        bank = out.val;
    }
    else
    {
        check = FMOD.RESULT.ERR_INVALID_HANDLE;
    }

    return bank;
}

function fmod_studio_system_get_event(studio: FMOD.StudioSystem, evpath: string)
{
    check = studio.getEvent(evpath, out);
    return out.val;
}

// ============================================================================
// Advanced Settings
// ============================================================================
function fmod_studio_system_get_advanced_settings(studio: FMOD.StudioSystem, 
    gmbuf: ArrayBuffer): void
{
    if (studio.isValid())
    {
        check = studio.getAdvancedSettings(out);
        let settings = out.val;
        if (check == FMOD.RESULT.OK)
        {
            let buf = new GMBuffer(gmbuf);
            buf.writeUint32(settings.commandqueuesize);
            buf.writeUint32(settings.handleinitialsize);
            buf.writeInt32(settings.studioupdateperiod);
            buf.writeInt32(settings.idlesampledatapoolsize);
            buf.writeUint32(settings.streamingscheduledelay);
            buf.writeString(settings.encryptionkey);
        }
    }
    else
    {
        check = FMOD.RESULT.ERR_INVALID_HANDLE;
    }
}

function fmod_studio_system_set_advanced_settings(studio: FMOD.StudioSystem,
    gmbuf: ArrayBuffer): void
{
    if (studio.isValid())
    {
        let settings = fmod.STUDIO_ADVANCEDSETTINGS();
        let buf = new GMBuffer(gmbuf);

        settings.commandqueuesize = buf.readUint32();
        settings.handleinitialsize = buf.readUint32();
        settings.studioupdateperiod = buf.readInt32();
        settings.idlesampledatapoolsize = buf.readInt32();
        settings.streamingscheduledelay = buf.readUint32();
        settings.encryptionkey = buf.readString();

        check = studio.setAdvancedSettings(settings);
    }
    else
    {
        check = FMOD.RESULT.ERR_INVALID_HANDLE;
    }
}
