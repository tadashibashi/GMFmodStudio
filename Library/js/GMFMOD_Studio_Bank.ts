function fmod_studio_bank_get_loading_state(bank: FMOD.Bank): number
{
    check = bank.getLoadingState(out);
    return out.val;
}

function fmod_studio_bank_load_sample_data(bank: FMOD.Bank): void
{
    check = bank.loadSampleData();
}

function fmod_studio_bank_unload_sample_data(bank: FMOD.Bank): void
{
    check = bank.unloadSampleData();
}

function fmod_studio_bank_get_sample_loading_state(bank: FMOD.Bank): number
{
    check = bank.getSampleLoadingState(out);
    return out.val;
}

function fmod_studio_bank_unload(bank: FMOD.Bank): void
{
    check = bank.unload();
}

function fmod_studio_bank_get_bus_count(bank: FMOD.Bank): number
{
    check = bank.getBusCount(out);
    return out.val;
}

function fmod_studio_bank_get_bus_list(bank: FMOD.Bank, capacity: number, 
    arr: Array<FMOD.Bus>): number
{
    if (bank.isValid())
    {
        check = bank.getBusCount(out);
        let count: number = out.val;
        if (check != FMOD.RESULT.OK) return 0;

        if (count > capacity) count = capacity;

        check = bank.getBusList(out, count, null);
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

function fmod_studio_bank_get_event_count(bank: FMOD.Bank): number
{
    check = bank.getEventCount(out);
    return out.val;
}

function fmod_studio_bank_get_event_list(bank: FMOD.Bank, capacity: number, 
    arr: Array<FMOD.EventDescription>): number
{
    if (bank.isValid())
    {
        check = bank.getEventCount(out);
        let count: number = out.val;
        if (check != FMOD.RESULT.OK) return 0;

        if (count > capacity) count = capacity;

        check = bank.getEventList(out, count, null);
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

function fmod_studio_bank_get_string_count(bank: FMOD.Bank): number
{
    check = bank.getStringCount(out);
    return out.val;
}

function fmod_studio_bank_get_string_info_id(bank: FMOD.Bank, gmbuf: ArrayBuffer,
    index: number): void
{
    if (bank.isValid())
    {
        let id = fmod.GUID();
        check = bank.getStringInfo(index, id, null, 0, null);

        let buf = new GMBuffer(gmbuf);
        if (check == FMOD.RESULT.OK)
        {
            buf.writeUint32(id.Data1);
            buf.writeUint16(id.Data2);
            buf.writeUint16(id.Data3);

            for (let i = 0; i < 8; ++i)
            {
                buf.writeUint8(id.Data4[i]);
            }
        }
    }
    else
    {
        check = FMOD.RESULT.ERR_INVALID_HANDLE;
    }
}

function fmod_studio_bank_get_string_info_path(bank: FMOD.Bank, index: number): string
{
    check = bank.getStringInfo(index, null, out, 256, null);
    return out.val;
}

function fmod_studio_bank_get_vca_count(bank: FMOD.Bank): number
{
    check = bank.getVCACount(out);
    return out.val;
}

function fmod_studio_bank_get_vca_list(bank: FMOD.Bank, capacity: number, 
    arr: Array<FMOD.VCA>): number
{
    if (bank.isValid())
    {
        check = bank.getVCACount(out);
        let count: number = out.val;
        if (check != FMOD.RESULT.OK) return 0;

        if (count > capacity) count = capacity;

        check = bank.getVCAList(out, count, null);
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

function fmod_studio_bank_get_id(bank: FMOD.Bank, gmbuf: ArrayBuffer): void
{
    check = bank.getID(out);
    if (check == FMOD.RESULT.OK)
    {
        let buf = new GMBuffer(gmbuf);
        let guid: FMOD.GUID = out.val;
        buf.writeUint32(guid.Data1);
        buf.writeUint16(guid.Data2);
        buf.writeUint16(guid.Data3);
        
        for (let i = 0; i < 8; ++i)
        {
            buf.writeUint8(guid.Data4[i]);
        }
    }
}

function fmod_studio_bank_get_path(bank: FMOD.Bank): string
{
    check = bank.getPath(out, 256, null);
    return out.val;
}

function fmod_studio_bank_is_valid(bank: FMOD.Bank): boolean
{
    return bank.isValid();
}
