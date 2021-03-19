#include "gmfs_common.h"
#include <iostream>

typedef FMOD::Studio::CommandReplay CommReplay;

gms_export void fmod_studio_comreplay_set_bank_path(char *ptr, char *path)
{
    static std::string str;
    str.assign(path);

    check = ((CommReplay *)ptr)->setBankPath(str.c_str());
}

FMOD_RESULT F_CALLBACK fmod_studio_comreplay_create_instance_callback(
    FMOD_STUDIO_COMMANDREPLAY *replay,
    int commandindex,
    FMOD_STUDIO_EVENTDESCRIPTION *eventdescription,
    FMOD_STUDIO_EVENTINSTANCE **instance,
    void *userdata
)
{
    FMOD_Studio_EventDescription_CreateInstance(eventdescription, instance);
    
    GM_DsMap map;
    map.AddString("fmodCallbackType", "CommandReplayCreateInstance");
    map.AddDouble("replay", (double)(uintptr_t)replay);
    map.AddDouble("commandindex", (double)commandindex);
    map.AddDouble("eventdescription", (double)(uintptr_t)eventdescription);
    map.AddDouble("instance", (double)(uintptr_t)*instance);
    map.AddDouble("userdata", (double)(uintptr_t)userdata); // ptr to userdata

    map.SendAsyncEvent();

    return FMOD_OK;
}

gms_export void fmod_studio_comreplay_set_create_instance_callback(char *ptr)
{
    check = ((CommReplay *)ptr)->setCreateInstanceCallback(
        (FMOD_STUDIO_COMMANDREPLAY_CREATE_INSTANCE_CALLBACK)fmod_studio_comreplay_create_instance_callback);
}

FMOD_RESULT F_CALLBACK fmod_studio_comreplay_frame_callback(
    FMOD_STUDIO_COMMANDREPLAY *replay,
    int commandindex,
    float currenttime,
    void *userdata
)
{
    GM_DsMap map;
    map.AddString("fmodCallbackType", "CommandReplayFrame");
    map.AddDouble("replay", (double)(uintptr_t)replay);
    map.AddDouble("commandindex", (double)commandindex);
    map.AddDouble("currenttime", (double)currenttime);
    map.AddDouble("userdata", (double)(uintptr_t)userdata); // ptr to userdata

    map.SendAsyncEvent();
    return FMOD_OK;
}

gms_export void fmod_studio_comreplay_set_frame_callback(char *ptr)
{
    check = ((CommReplay *)ptr)->setFrameCallback(
        (FMOD_STUDIO_COMMANDREPLAY_FRAME_CALLBACK)fmod_studio_comreplay_frame_callback);
}

FMOD_RESULT F_CALLBACK fmod_studio_comreplay_load_bank_callback(
    FMOD_STUDIO_COMMANDREPLAY *replay,
    int commandindex,
    const FMOD_GUID *bankguid,
    const char *bankfilename,
    FMOD_STUDIO_LOAD_BANK_FLAGS flags,
    FMOD_STUDIO_BANK **bank,
    void *userdata
)
{
    FMOD_STUDIO_SYSTEM *sys;
    FMOD_Studio_CommandReplay_GetSystem(replay, &sys);

    FMOD_RESULT result;
    result = FMOD_Studio_System_LoadBankFile(sys, bankfilename, flags, bank);

    if (result != FMOD_OK) return result;

    GM_DsMap map;
    map.AddString("fmodCallbackType", "CommandReplayLoadBank");
    map.AddDouble("replay", (double)(uintptr_t)replay);
    map.AddDouble("commandindex", (double)commandindex);
    map.AddString("bankfilename", bankfilename);
    map.AddDouble("flags", (double)flags);
    map.AddDouble("bank", (double)flags);
    map.AddDouble("userdata", (double)(uintptr_t)userdata); // ptr to userdata

    map.SendAsyncEvent();

    return FMOD_OK;
}

gms_export void fmod_studio_comreplay_set_load_bank_callback(char *ptr)
{
    check = ((CommReplay *)ptr)->setLoadBankCallback(
        (FMOD_STUDIO_COMMANDREPLAY_LOAD_BANK_CALLBACK)fmod_studio_comreplay_load_bank_callback);
}

gms_export void fmod_studio_comreplay_start(char *ptr)
{
    check = ((CommReplay *)ptr)->start();
}

gms_export void fmod_studio_comreplay_stop(char *ptr)
{
    check = ((CommReplay *)ptr)->stop();
}

gms_export double fmod_studio_comreplay_get_current_command_index(char *ptr)
{
    int command{ };
    check = ((CommReplay *)ptr)->getCurrentCommand(&command, nullptr);

    return static_cast<double>(command);
}

gms_export double fmod_studio_comreplay_get_current_command_time(char *ptr)
{
    float time{ };
    check = ((CommReplay *)ptr)->getCurrentCommand(nullptr, &time);

    return static_cast<double>(time);
}

gms_export double fmod_studio_comreplay_get_playback_state(char *ptr)
{
    FMOD_STUDIO_PLAYBACK_STATE state{ };
    check = ((CommReplay *)ptr)->getPlaybackState(&state);

    return static_cast<double>(state);
}

gms_export void fmod_studio_comreplay_set_paused(char *ptr, double paused)
{
    check = ((CommReplay *)ptr)->setPaused((bool)paused);
}

gms_export double fmod_studio_comreplay_get_paused(char *ptr)
{
    bool paused{ };
    check = ((CommReplay *)ptr)->getPaused(&paused);

    return static_cast<double>(paused);
}

gms_export void fmod_studio_comreplay_seek_to_command(char *ptr, double commandindex)
{
    check = ((CommReplay *)ptr)->seekToCommand((int)commandindex);;
}

gms_export void fmod_studio_comreplay_seek_to_time(char *ptr, double time)
{
    check = ((CommReplay *)ptr)->seekToTime((float)time);
}

gms_export double fmod_studio_comreplay_get_command_at_time(char *ptr, double time)
{
    int command{ };
    check = ((CommReplay *)ptr)->getCommandAtTime((float)time, &command);

    return static_cast<double>(command);
}

gms_export double fmod_studio_comreplay_get_command_count(char *ptr)
{
    int count{ };
    check = ((CommReplay *)ptr)->getCommandCount(&count);

    return static_cast<double>(count);
}

gms_export void fmod_studio_comreplay_get_command_info(char *ptr, double commandindex, char *gmbuf)
{
    auto com = (FMOD::Studio::CommandReplay *)ptr;
    if (com->isValid())
    {
        FMOD_STUDIO_COMMAND_INFO info;
        check = com->getCommandInfo((int)commandindex, &info);

        Buffer buf(gmbuf);
        buf.write_char_star(info.commandname);
        buf.write<int32_t>(info.parentcommandindex);
        buf.write<int32_t>(info.framenumber);
        buf.write(info.frametime);
        buf.write<uint32_t>(info.instancetype);
        buf.write<uint32_t>(info.outputtype);
        buf.write<uint32_t>(info.instancehandle);
        buf.write<uint32_t>(info.outputhandle);
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }
}

gms_export const char *fmod_studio_comreplay_get_command_string(char *ptr, double commandindex)
{
    static std::string str;

    auto com = (FMOD::Studio::CommandReplay *)ptr;
    if (com && com->isValid())
    {
        char cstr[PATH_MAX_LENGTH];
        check = com->getCommandString((int)commandindex , cstr, PATH_MAX_LENGTH);
        str.assign(cstr);
    }

    return str.c_str();
}

// Retrieves total playback time, or -1 on error.
gms_export double fmod_studio_comreplay_get_length(char *ptr)
{
    float time{ };
    check = ((CommReplay *)ptr)->getLength(&time);

    return static_cast<double>(time);
}

gms_export double fmod_studio_comreplay_get_system(char *ptr)
{
    FMOD::Studio::System *sys{ };
    check = ((CommReplay *)ptr)->getSystem(&sys);

    return (double)(uintptr_t)sys;
}

// Get User data, not implemented

gms_export double fmod_studio_comreplay_is_valid(char *ptr)
{
    return ((CommReplay *)ptr)->isValid();
}

gms_export void fmod_studio_comreplay_release(char *ptr)
{
    check = ((CommReplay *)ptr)->release();
}
