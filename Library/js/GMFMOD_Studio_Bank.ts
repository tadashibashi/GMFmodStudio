function fmod_studio_bank_get_loading_state(bank: FMOD.Bank): number
{
    check = bank.getLoadingState(out);
    return out.val;
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

function fmod_studio_bank_is_valid(bank: FMOD.Bank): boolean
{
    return bank.isValid();
}
