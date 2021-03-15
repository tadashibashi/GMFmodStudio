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
    GMFMOD_CHECK(check);
    var gSystem = out.val;

    check = gSystem.getDriverInfo(0, null, null, out, null, null);
    GMFMOD_CHECK(check);
    check = gSystem.setSoftwareFormat(out.val, FMOD.SPEAKERMODE.DEFAULT, 0);
    GMFMOD_CHECK(check);

    check = gSystem.setDSPBufferSize(2048, 2);
    GMFMOD_CHECK(check);

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
    return out.val;
}

function fmod_studio_system_unload_all(studio: FMOD.StudioSystem): void
{
    check = studio.unloadAll();
}

function fmod_studio_system_get_bank(studio: FMOD.StudioSystem, 
    bankpath: string): FMOD.Bank
{
    check = studio.getBank(bankpath, out);

    return out.val;
}

function fmod_studio_system_get_bank_count(studio: FMOD.StudioSystem): number
{
    check = studio.getBankCount(out);
    return out.val;
}

function fmod_studio_system_get_bank_list(studio: FMOD.StudioSystem,
    capacity: number, arr: FMOD.Bank[]): number
{
    if (studio.isValid())
    {
        check = studio.getBankCount(out);
        let count: number = out.val;
        if (check != FMOD.RESULT.OK) return 0;

        if (count > capacity) count = capacity;

        check = studio.getBankList(out, count, null);
        arr.length = count;
        if (check == FMOD.RESULT.OK)
        {
            for (let i = 0; i < count; ++i)
            {
                arr[i] = out.val[i];
            }
        }

        return count;
    }
    else
    {
        check = FMOD.RESULT.ERR_INVALID_HANDLE;
    }

    return 0;
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

// ============================================================================
// Listeners
// ============================================================================

function fmod_studio_system_set_listener_attributes(studio: FMOD.StudioSystem,
    listenerindex: number, gmbuf: ArrayBuffer): void
{
    if (studio.isValid())
    {
        let buf = new GMBuffer(gmbuf);
        let attr = fmod._3D_ATTRIBUTES();
        attr.position.x = buf.readFloat32();
        attr.position.y = buf.readFloat32();
        attr.position.z = buf.readFloat32();
        attr.velocity.x = buf.readFloat32();
        attr.velocity.y = buf.readFloat32();
        attr.velocity.z = buf.readFloat32();
        attr.forward.x =  buf.readFloat32();
        attr.forward.y =  buf.readFloat32();
        attr.forward.z =  buf.readFloat32();
        attr.up.x =       buf.readFloat32();
        attr.up.y =       buf.readFloat32();
        attr.up.z =       buf.readFloat32();
    
        check = studio.setListenerAttributes(listenerindex, attr, 0);
    }
    else
    {
        check = FMOD.RESULT.ERR_INVALID_HANDLE;
    }
}

function fmod_studio_system_get_listener_attributes(studio: FMOD.StudioSystem,
    listenerindex: number, gmbuf: ArrayBuffer): void
{
   
    check = studio.getListenerAttributes(listenerindex, out, 0);

    if (check != FMOD.RESULT.OK) return;

    let attr = out as any;

    let buf = new GMBuffer(gmbuf);
    buf.writeFloat32(attr["position.x"]);
    buf.writeFloat32(attr["position.y"]);
    buf.writeFloat32(attr["position.z"]);
    buf.writeFloat32(attr["velocity.x"]);
    buf.writeFloat32(attr["velocity.y"]);
    buf.writeFloat32(attr["velocity.z"]);
    buf.writeFloat32(attr["forward.x"]);
    buf.writeFloat32(attr["forward.y"]);
    buf.writeFloat32(attr["forward.z"]);
    buf.writeFloat32(attr["up.x"]);
    buf.writeFloat32(attr["up.y"]);
    buf.writeFloat32(attr["up.z"]);
}

function fmod_studio_system_set_listener_weight(studio: FMOD.StudioSystem,
    listenerindex: number, weight: number): void
{
    check = studio.setListenerWeight(listenerindex, weight);
}

function fmod_studio_system_get_listener_weight(studio: FMOD.StudioSystem,
    listenerindex: number): number
{
    check = studio.getListenerWeight(listenerindex, out);
    return out.val;
}

function fmod_studio_system_set_num_listeners(studio: FMOD.StudioSystem,
    listeners: number): void
{
    check = studio.setNumListeners(listeners);
}

function fmod_studio_system_get_num_listeners(studio: FMOD.StudioSystem): number
{
    check = studio.getNumListeners(out);
    return out.val;
}


// ============================================================================
// Busses
// ============================================================================
function fmod_studio_system_get_bus(studio: FMOD.StudioSystem, path: string): FMOD.Bank
{
    check = studio.getBus(path, out);
    return out.val;
}

function fmod_studio_system_get_bus_by_id(studio: FMOD.StudioSystem, 
    gmbuf: ArrayBuffer): FMOD.Bus
{
    if (studio.isValid())
    {
        let buf = new GMBuffer(gmbuf);
        let guid = fmod.GUID();
        guid.Data1 = buf.readUint32();
        guid.Data2 = buf.readUint16();
        guid.Data3 = buf.readUint16();
        
        for (let i = 0; i < 8; ++i)
        {
            guid.Data4[i] = buf.readUint8();
        }

        check = studio.getBusByID(guid, out);
        return out.val;
    }
    else
    {
        check = FMOD.RESULT.ERR_INVALID_HANDLE;
    }

    return null;
}


// ============================================================================
// Events
// ============================================================================

function fmod_studio_system_get_event(studio: FMOD.StudioSystem, evpath: string)
{
    check = studio.getEvent(evpath, out);
    return out.val;
}

function fmod_studio_system_get_event_by_id(studio: FMOD.StudioSystem, 
    gmbuf: ArrayBuffer): FMOD.EventDescription
{
    if (studio.isValid())
    {
        let buf = new GMBuffer(gmbuf);
        let guid = fmod.GUID();
        guid.Data1 = buf.readUint32();
        guid.Data2 = buf.readUint16();
        guid.Data3 = buf.readUint16();
        
        for (let i = 0; i < 8; ++i)
        {
            guid.Data4[i] = buf.readUint8();
        }

        check = studio.getEventByID(guid, out);
        return out.val;
    }
    else
    {
        check = FMOD.RESULT.ERR_INVALID_HANDLE;
    }

    return null;
}

// ============================================================================
// Parameters
// ============================================================================
function fmod_studio_system_set_parameter_by_name(studio: FMOD.StudioSystem,
    name: string, value: number, ignoreseekspeed: boolean): void
{
    check = studio.setParameterByName(name, value, ignoreseekspeed);
}

function fmod_studio_system_get_parameter_by_name(studio: FMOD.StudioSystem,
    name: string): number
{
    check = studio.getParameterByName(name, out, null);
    return out.val;
}

function fmod_studio_system_get_parameter_by_name_final(studio: FMOD.StudioSystem,
    name: string): number
{
    check = studio.getParameterByName(name, null, out);
    return out.val;
}

function fmod_studio_system_set_parameter_by_id(studio: FMOD.StudioSystem,
    gmbuf: ArrayBuffer, value: number, ignoreseekspeed: boolean): void
{
    if (studio.isValid())
    {
        let buf = new GMBuffer(gmbuf);
        let pid = fmod.STUDIO_PARAMETER_ID();
        pid.data1 = buf.readUint32();
        pid.data2 = buf.readUint32();

        check = studio.setParameterByID(pid, value, ignoreseekspeed);
    }
    else
    {
        check = FMOD.RESULT.ERR_INVALID_HANDLE;
    }
}

function fmod_studio_system_set_parameters_by_ids(studio: FMOD.StudioSystem,
    gmbuf: ArrayBuffer, count: number, ignoreseekspeed: boolean): void
{
    let ids    = new Array<FMOD.STUDIO_PARAMETER_ID>(count);
    let values = new Array<number>(count);
    let buf    = new GMBuffer(gmbuf);

    for (let i = 0; i < count; ++i)
    {
        let pid = fmod.STUDIO_PARAMETER_ID();
        pid.data1 = buf.readUint32();
        pid.data2 = buf.readUint32();

        ids[i] = pid;
        values[i] = buf.readFloat32();
    }

    check = studio.setParametersByIDs(ids, values, count, ignoreseekspeed);
}

function fmod_studio_system_get_parameter_by_id(studio: FMOD.StudioSystem,
    gmbuf: ArrayBuffer): number
{
    let buf = new GMBuffer(gmbuf);
    let pid = fmod.STUDIO_PARAMETER_ID();

    pid.data1 = buf.readUint32();
    pid.data2 = buf.readUint32();

    check = studio.getParameterByID(pid, out, null);

    return out.val;
}

function fmod_studio_system_get_parameter_by_id_final(studio: FMOD.StudioSystem,
    gmbuf: ArrayBuffer): number
{
    let buf = new GMBuffer(gmbuf);
    let pid = fmod.STUDIO_PARAMETER_ID();

    pid.data1 = buf.readUint32();
    pid.data2 = buf.readUint32();

    check = studio.getParameterByID(pid, null, out);

    return out.val;
}

function fmod_studio_system_get_paramdesc_count(studio: FMOD.StudioSystem): number
{
    check = studio.getParameterDescriptionCount(out);
    return out.val;
}

let fmod_studio_global_params = new Array<FMOD.STUDIO_PARAMETER_DESCRIPTION>();
let fmod_studio_global_params_queried: FMOD.StudioSystem = null;

function fmod_studio_system_get_paramdesc_by_index(studio: FMOD.StudioSystem,
    index: number, gmbuf: ArrayBuffer): void
{
    if (studio.isValid())
    {
        if (fmod_studio_global_params_queried !== studio)
        {
            fmod_studio_global_params = []; // dereference and clear array
            check = studio.getParameterDescriptionCount(out);

            if (check != FMOD.RESULT.OK) return;
            let count: number = out.val;

            if (count > 0)
            {
                let params = {};
                check = studio.getParameterDescriptionList(params as any, count, null);
                
                if (check != FMOD.RESULT.OK) return;
                
                fmod_studio_global_params = params as any;
            }

            fmod_studio_global_params_queried = studio;
        }

        if (index >= fmod_studio_global_params.length)
        {
            console.error("GMFMOD Error! Queried an index of global parameter "
                + "descriptions that was out of range!");
            return;
        }

        let param = fmod_studio_global_params[index];

        let buf = new GMBuffer(gmbuf);
        buf.writeCharStar(param.name);
        buf.writeUint32(param.id.data1);
        buf.writeUint32(param.id.data2);
        buf.writeFloat32(param.minimum);
        buf.writeFloat32(param.maximum);
        buf.writeFloat32(param.defaultvalue);
        buf.writeUint32(param.type);
        buf.writeUint32(param.flags);
    }
    else
    {
        check = FMOD.RESULT.ERR_INVALID_HANDLE;
    }
}

// ============================================================================
// VCA
// ============================================================================
function fmod_studio_system_get_vca(studio: FMOD.StudioSystem, 
    path: string): FMOD.VCA
{
    check = studio.getVCA(path, out);
    return out.val;
}

function fmod_studio_system_get_vca_by_id(studio: FMOD.StudioSystem, 
    gmbuf: ArrayBuffer): FMOD.VCA
{
    if (studio.isValid())
    {
        let buf = new GMBuffer(gmbuf);
        let guid = fmod.GUID();
        guid.Data1 = buf.readUint32();
        guid.Data2 = buf.readUint16();
        guid.Data3 = buf.readUint16();
        
        for (let i = 0; i < 8; ++i)
        {
            guid.Data4[i] = buf.readUint8();
        }

        check = studio.getVCAByID(guid, out);
        return out.val;
    }
    else
    {
        check = FMOD.RESULT.ERR_INVALID_HANDLE;
    }

    return null;
}

// ============================================================================
// Advanced Settings
// ============================================================================
function fmod_studio_system_get_advanced_settings(studio: FMOD.StudioSystem, 
    gmbuf: ArrayBuffer): void
{
    console.warn("FMOD::Studio::System::getAdvancedSettings not supported in HTML5");
    // if (studio.isValid())
    // {
    //     let settings = fmod.STUDIO_ADVANCEDSETTINGS();
    //     check = studio.getAdvancedSettings(out);
    //     console.log(out);
    //     settings = out.val;
    //     if (check == FMOD.RESULT.OK)
    //     {
    //         let buf = new GMBuffer(gmbuf);
    //         buf.writeUint32(settings.commandqueuesize);
    //         buf.writeUint32(settings.handleinitialsize);
    //         buf.writeInt32(settings.studioupdateperiod);
    //         buf.writeInt32(settings.idlesampledatapoolsize);
    //         buf.writeUint32(settings.streamingscheduledelay);
    //         buf.writeString(settings.encryptionkey);
    //     }
    // }
    // else
    // {
    //     check = FMOD.RESULT.ERR_INVALID_HANDLE;
    // }
}

function fmod_studio_system_set_advanced_settings(studio: FMOD.StudioSystem,
    gmbuf: ArrayBuffer): void
{
    console.warn("FMOD::Studio::System::setAdvancedSettings not supported in HTML5");
    // if (studio.isValid())
    // {
    //     let settings = fmod.STUDIO_ADVANCEDSETTINGS();
    //     let buf = new GMBuffer(gmbuf);

    //     settings.commandqueuesize = buf.readUint32();
    //     settings.handleinitialsize = buf.readUint32();
    //     settings.studioupdateperiod = buf.readInt32();
    //     settings.idlesampledatapoolsize = buf.readInt32();
    //     settings.streamingscheduledelay = buf.readUint32();
    //     settings.encryptionkey = buf.readString();

    //     check = studio.setAdvancedSettings(settings);
    // }
    // else
    // {
    //     check = FMOD.RESULT.ERR_INVALID_HANDLE;
    // }
}

// ============================================================================
// Command Capture and Replay
// ============================================================================
function fmod_studio_system_start_command_capture(studio: FMOD.StudioSystem,
    filename: string, flags: FMOD.STUDIO_COMMANDCAPTURE_FLAGS): void
{
    check = studio.startCommandCapture(filename, flags);
}

function fmod_studio_system_stop_command_capture(studio: FMOD.StudioSystem)
{
    check = studio.stopCommandCapture();
}

function fmod_studio_system_load_command_replay(studio: FMOD.StudioSystem,
    filename: string, flags: FMOD.STUDIO_COMMANDREPLAY_FLAGS): FMOD.CommandReplay
{
    check = studio.loadCommandReplay(filename, flags, out);
    return out.val as FMOD.CommandReplay;
}

// ============================================================================
// Profiling
// ============================================================================
function fmod_studio_system_get_buffer_usage(studio: FMOD.StudioSystem,
    gmbuf: ArrayBuffer): void
{
    let usage: any = {};
    check = studio.getBufferUsage(usage);
    if (check === FMOD.RESULT.OK)
    {
        let buf = new GMBuffer(gmbuf);
        buf.writeInt32(usage["studiocommandqueue.currentusage"]);
        buf.writeInt32(usage["studiocommandqueue.peakusage"]);
        buf.writeInt32(usage["studiocommandqueue.capacity"]);
        buf.writeInt32(usage["studiocommandqueue.stallcount"]);
        buf.writeFloat32(usage["studiocommandqueue.stalltime"]);
        buf.writeInt32(usage["studiohandle.currentusage"]);
        buf.writeInt32(usage["studiohandle.peakusage"]);
        buf.writeInt32(usage["studiohandle.capacity"]);
        buf.writeInt32(usage["studiohandle.stallcount"]);
        buf.writeFloat32(usage["studiohandle.stalltime"]);
    }
}

function fmod_studio_system_reset_buffer_usage(studio: FMOD.StudioSystem): void
{
    check = studio.resetBufferUsage();
}

function fmod_studio_system_get_cpu_usage(studio: FMOD.StudioSystem, 
    gmbuf: ArrayBuffer): void
{
    var usage: any = {};
    check = studio.getCPUUsage(usage);

    if (check === FMOD.RESULT.OK)
    {
        let buf = new GMBuffer(gmbuf);
        buf.writeFloat32(usage.dspusage);
        buf.writeFloat32(usage.streamusage);
        buf.writeFloat32(usage.geometryusage);
        buf.writeFloat32(usage.updateusage);
        buf.writeFloat32(usage.studiousage);
    }
}

function fmod_studio_system_get_memory_usage(studio: FMOD.StudioSystem,
    gmbuf: ArrayBuffer): void
{
    console.warn("FMOD::Studio::System::getMemoryUsage not supported on HTML5");
    // let usage: any = {};
    // check = studio.getMemoryUsage(usage);
    // if (check === FMOD.RESULT.OK)
    // {
    //     let buf = new GMBuffer(gmbuf);
    //     buf.writeInt32(usage.exclusive);
    //     buf.writeInt32(usage.inclusive);
    //     buf.writeInt32(usage.sampledata);
    // }
}

// ============================================================================
// Custom DSP Plug-ins (not supported via GameMaker extension)
// ============================================================================

// ============================================================================
// General
// ============================================================================
function fmod_studio_system_callback(system: FMOD.StudioSystem, 
    type: FMOD.STUDIO_SYSTEM_CALLBACK_TYPE, commanddata:any, 
    userdata:any): FMOD.RESULT
{
    let map: any = {};
	map["fmodCallbackType"] = "StudioSystem";
	map["system"] = system;
	map["type"] = type;
    map["commanddata"] = commanddata;
    map["userdata"] = userdata; 

	GMS_API.send_async_event_social(map);

    return FMOD.RESULT.OK;
}

function fmod_studio_system_set_callback(studio: FMOD.StudioSystem,
    callbackmask: number): void
{
    check = studio.setCallback(fmod_studio_system_callback, callbackmask);
}

function fmod_studio_system_get_core_system(studio: FMOD.StudioSystem): FMOD.System
{
    check = studio.getCoreSystem(out);
    return out.val;
}

function fmod_studio_system_lookup_id(studio: FMOD.StudioSystem, path: string,
    gmbuf: ArrayBuffer): void
{
    let guid: FMOD.GUID = fmod.GUID();
    check = studio.lookupID(path, guid as any);
    if (check == FMOD.RESULT.OK)
    {
        let buf = new GMBuffer(gmbuf);
        
        buf.writeUint32(guid.Data1);
        buf.writeUint16(guid.Data2);
        buf.writeUint16(guid.Data3);
        
        for (let i = 0; i < 8; ++i)
        {
            buf.writeUint8(guid.Data4[i]);
        }
    }
}

function fmod_studio_system_lookup_path(studio: FMOD.StudioSystem, 
    gmbuf: ArrayBuffer): string
{
    if (studio.isValid())
    {
        let guid = fmod.GUID();
        let buf = new GMBuffer(gmbuf);

        guid.Data1 = buf.readUint32();
        guid.Data2 = buf.readUint16();
        guid.Data3 = buf.readUint16();
        
        for (let i = 0; i < 8; ++i)
        {
            guid.Data4[i] = buf.readUint8();
        }

        check = studio.lookupPath(guid, out, 128, null);

        return out.val;
    }
    else
    {
        check = FMOD.RESULT.ERR_INVALID_HANDLE;
    }

    return "";
}


function fmod_studio_system_is_valid(studio: FMOD.StudioSystem): boolean
{
    return studio.isValid();
}
