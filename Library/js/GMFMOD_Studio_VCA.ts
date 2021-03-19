function fmod_studio_vca_set_volume(vca: FMOD.VCA, volume: number): void
{
    check = vca.setVolume(volume);
}

function fmod_studio_vca_get_volume(vca: FMOD.VCA): number
{
    check = vca.getVolume(out, null);
    return out.val;
}

function fmod_studio_vca_get_volume_final(vca: FMOD.VCA): number
{
    check = vca.getVolume(null, out);
    return out.val;
}

function fmod_studio_vca_get_id(vca: FMOD.VCA, gmbuf: ArrayBuffer): void
{
    check = vca.getID(out);
    if (check == FMOD.RESULT.OK)
    {
        let guid = out.val;
        let buf = new GMBuffer(gmbuf);
        buf.writeUint32(guid["Data1"]);
        buf.writeUint16(guid["Data2"]);
        buf.writeUint16(guid["Data3"]);

        for (let i = 0; i < 8; ++i)
        {
            buf.writeUint8(guid["Data4"][i]);
        }
    }
}

function fmod_studio_vca_get_path(vca: FMOD.VCA): string
{
    check = vca.getPath(out, 256, null);
    return out.val;
}

function fmod_studio_vca_is_valid(vca: FMOD.VCA): boolean
{
    return vca.isValid();
}