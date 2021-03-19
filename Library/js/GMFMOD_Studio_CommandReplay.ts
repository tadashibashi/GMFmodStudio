function fmod_studio_comreplay_set_bank_path(comrep: FMOD.CommandReplay,
    path: string): void
{
    check = comrep.setBankPath(path);
}

// function fmod_studio_comreplay_create_instance_callback(replay: FMOD.CommandReplay,
//     commandindex: number,
//     eventdescription: FMOD.EventDescription,
//     eventinstanceOut: Out<FMOD.EventInstance>,
//     userdata: any): FMOD.RESULT
// {
//     let map: any = {};
//     check = eventdescription.createInstance(eventinstanceOut);

//     map["fmodCallbackType"] = "CommandReplayCreateInstance";
//     map["replay"] = replay;
//     map["commandindex"] = commandindex;
//     map["eventdescription"] = eventdescription;
//     map["instance"] = eventinstanceOut.val;
//     map["userdata"] = userdata;

//     GMS_API.send_async_event_social(map);

//     return check;
// }

function fmod_studio_comreplay_set_create_instance_callback(comrep: FMOD.CommandReplay): void
{
    console.warn("FMOD_STUDIO_COMMANDREPLAY_CREATE_INSTANCE_CALLBACK currently not supported in HTML5");
    //check = comrep.setCreateInstanceCallback(fmod_studio_comreplay_create_instance_callback);
}

// function fmod_studio_comreplay_load_bank_callback(replay: FMOD.CommandReplay,
//     commandindex: number,
//     bankguid: FMOD.GUID,
//     bankfilename: string,
//     flags: FMOD.STUDIO_LOAD_BANK_FLAGS,
//     bankOut: Out<FMOD.Bank>,
//     userdata: any): FMOD.RESULT
// {
//     let result = replay.getSystem(out);
//     if (result != FMOD.RESULT.OK) return result;

//     let sys: FMOD.StudioSystem = out.val;
//     result = sys.loadBankFile(bankfilename, flags, bankOut);

//     let map: any = {};
//     map["fmodCallbackType"] = "CommandReplayLoadBank";
//     map["replay"] = replay;
//     map["commandindex"] = commandindex;
//     map["bankfilename"] = bankfilename;
//     map["flags"] = flags;
//     map["bank"] = bankOut.val;
//     map["userdata"] = userdata;

//     return result;
// }

function fmod_studio_comreplay_set_load_bank_callback(comrep: FMOD.CommandReplay): void
{
    console.warn("FMOD_STUDIO_COMMANDREPLAY_LOAD_BANK_CALLBACK currently not supported in HTML5");
    //check = comrep.setLoadBankCallback(fmod_studio_comreplay_load_bank_callback);
}

// function fmod_studio_comrep_frame_callback(replay: FMOD.CommandReplay,
//     commandindex: number, currenttime: number, userdata: any): FMOD.RESULT
// {
//     let map: any = {};
//     map["fmodCallbackType"] = "CommandReplayFrame";
//     map["replay"] = replay;
//     map["commandindex"] = commandindex;
//     map["currenttime"] = currenttime;
//     map["userdata"] = userdata;

//     return FMOD.RESULT.OK;
// }

function fmod_studio_comreplay_set_frame_callback(comrep: FMOD.CommandReplay): void
{
    console.warn("FMOD_STUDIO_COMMANDREPLAY_FRAME_CALLBACK currently not supported in HTML5");
    //check = comrep.setFrameCallback(fmod_studio_comrep_frame_callback);
}

function fmod_studio_comreplay_start(comrep: FMOD.CommandReplay): void
{
    check = comrep.start();
}

function fmod_studio_comreplay_stop(comrep: FMOD.CommandReplay): void
{
    check = comrep.stop();
}

function fmod_studio_comreplay_get_current_command_index(comrep: FMOD.CommandReplay): number
{
    check = comrep.getCurrentCommand(out, null);
    return out.val;
}

function fmod_studio_comreplay_get_current_command_time(comrep: FMOD.CommandReplay): number
{
    check = comrep.getCurrentCommand(null, out);
    return out.val;
}

function fmod_studio_comreplay_get_playback_state(
    comrep: FMOD.CommandReplay): FMOD.STUDIO_PLAYBACK_STATE
{
    check = comrep.getPlaybackState(out);
    return out.val;
}

function fmod_studio_comreplay_set_paused(comrep: FMOD.CommandReplay, 
    paused: boolean): void
{
    check = comrep.setPaused(paused);
}

function fmod_studio_comreplay_get_paused(comrep: FMOD.CommandReplay): boolean
{
    check = comrep.getPaused(out);
    return out.val;
}

function fmod_studio_comreplay_seek_to_command(comrep: FMOD.CommandReplay, 
    commandindex: number): void
{
    check = comrep.seekToCommand(commandindex);
}

function fmod_studio_comreplay_seek_to_time(comrep: FMOD.CommandReplay, 
    time: number): void
{
    check = comrep.seekToTime(time);
}

function fmod_studio_comreplay_get_command_at_time(comrep: FMOD.CommandReplay, 
    time: number): number
{
    check = comrep.getCommandAtTime(time, out);
    return out.val;
}

function fmod_studio_comreplay_get_command_count(comrep: FMOD.CommandReplay): number
{
    check = comrep.getCommandCount(out);
    return out.val;
}

function fmod_studio_comreplay_get_command_info(comrep: FMOD.CommandReplay,
    commandindex: number, gmbuf: ArrayBuffer): void
{
    if (comrep.isValid())
    {
        let info = fmod.STUDIO_COMMAND_INFO();
        check = comrep.getCommandInfo(commandindex, info);

        let buf = new GMBuffer(gmbuf);
        buf.writeCharStar(info["commandname"]);
        buf.writeInt32(info["parentcommandindex"]);
        buf.writeInt32(info["framenumber"]);
        buf.writeFloat32(info["frametime"]);
        buf.writeUint32(info["instancetype"]);
        buf.writeUint32(info["outputtype"]);
        buf.writeUint32(info["instancehandle"]);
        buf.writeUint32(info["outputhandle"]);
    }
    else
    {
        check = FMOD.RESULT.ERR_INVALID_HANDLE;
    }
}

function fmod_studio_comreplay_get_command_string(comrep: FMOD.CommandReplay,
    commandindex: number): string
{
    check = comrep.getCommandString(commandindex, out);
    return out.val;
}

function fmod_studio_comreplay_get_length(comrep: FMOD.CommandReplay): number
{
    check = comrep.getLength(out);
    return out.val;
}

function fmod_studio_comreplay_get_system(comrep: FMOD.CommandReplay): FMOD.StudioSystem
{
    check = comrep.getSystem(out);
    return out.val;
}

function fmod_studio_comreplay_is_valid(comrep: FMOD.CommandReplay): boolean
{
    return comrep !== undefined && comrep.isValid();
}

function fmod_studio_comreplay_release(comrep: FMOD.CommandReplay): void
{
    check = comrep.release();
}
