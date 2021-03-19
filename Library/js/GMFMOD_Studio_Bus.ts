function fmod_studio_bus_set_paused(bus: FMOD.Bus, paused: boolean): void
{
    check = bus.setPaused(paused);
}

function fmod_studio_bus_get_paused(bus: FMOD.Bus): boolean
{
    check = bus.getPaused(out);
    return out.val;
}

function fmod_studio_bus_set_volume(bus: FMOD.Bus, volume: number): void
{
    check = bus.setVolume(volume);
}

function fmod_studio_bus_get_volume(bus: FMOD.Bus): number
{
    check = bus.getVolume(out, null);
    return out.val;
}

function fmod_studio_bus_get_volume_final(bus: FMOD.Bus): number
{
    check = bus.getVolume(null, out);
    return out.val;
}

function fmod_studio_bus_set_mute(bus: FMOD.Bus, mute: boolean): void
{
    check = bus.setMute(mute);
}

function fmod_studio_bus_get_mute(bus: FMOD.Bus): boolean
{
    check = bus.getMute(out);
    return out.val;
}

function fmod_studio_bus_get_channel_group(bus: FMOD.Bus): FMOD.ChannelGroup
{
    check = bus.getChannelGroup(out);
    return out.val;
}

function fmod_studio_bus_lock_channel_group(bus: FMOD.Bus): void
{
    check = bus.lockChannelGroup();
}

function fmod_studio_bus_unlock_channel_group(bus: FMOD.Bus): void
{
    check = bus.unlockChannelGroup();
}

function fmod_studio_bus_stop_all_events(bus: FMOD.Bus, 
    mode: FMOD.STUDIO_STOP_MODE): void
{
    check = bus.stopAllEvents(mode);
}

function fmod_studio_bus_get_cpu_usage_exclusive(bus: FMOD.Bus): number
{
    console.warn("FMOD::Studio::Bus::getCPUUsage not supported in HTML5");
    return -1;
    // check = bus.getCPUUsage(out, null);
    // return out.val;
}

function fmod_studio_bus_get_cpu_usage_inclusive(bus: FMOD.Bus): number
{
    console.warn("FMOD::Studio::Bus::getCPUUsage not supported in HTML5");
    // check = bus.getCPUUsage(null, out);
    // return out.val;
    return -1;
}

function fmod_studio_bus_get_memory_usage(bus: FMOD.Bus, gmbuf: ArrayBuffer): void
{
    console.warn("FMOD::Studio::Bus::getMemoryUsage not supported in HTML5");
    // let usage = fmod.STUDIO_MEMORY_USAGE();
    // check = bus.getMemoryUsage(usage);
    // if (check == FMOD.RESULT.OK)
    // {
    //     let buf = new GMBuffer(gmbuf);
    //     buf.writeInt32(usage.exclusive);
    //     buf.writeInt32(usage.inclusive);
    //     buf.writeInt32(usage.sampledata);
    // }
}

function fmod_studio_bus_get_id(bus: FMOD.Bus, gmbuf: ArrayBuffer): void
{
    check = bus.getID(out);
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

function fmod_studio_bus_get_path(bus: FMOD.Bus): string
{
    check = bus.getPath(out, 256, null);
    return out.val;
}

function fmod_studio_bus_is_valid(bus: FMOD.Bus): boolean
{
    return bus.isValid();
}