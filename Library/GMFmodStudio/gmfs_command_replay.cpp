#include "gmfs_common.h"
#include <iostream>

gms_export double fmod_studio_comreplay_set_bank_path(char *ptr, char *path)
{
    static std::string str;
    str.assign(path);
    double ret = -1;

    auto com = (FMOD::Studio::CommandReplay *)ptr;
    if (com && com->isValid())
    {
        check = com->setBankPath(str.c_str());
        if (check == FMOD_OK) ret = 0;
    }

    return ret;
}

FMOD_RESULT F_CALLBACK fmod_studio_comreplay_create_instance_callback(
    FMOD_STUDIO_COMMANDREPLAY *replay,
    int commandindex,
    FMOD_STUDIO_EVENTDESCRIPTION *eventdescription,
    FMOD_STUDIO_EVENTINSTANCE **instance,
    void *userdata
)
{
    GM_DsMap map;
    map.AddString("fmodCallbackType", "CommandReplayCreateInstance");
    map.AddDouble("replay", (double)(uintptr_t)replay);
    map.AddDouble("commandindex", (double)commandindex);
    map.AddDouble("eventdescription", (double)(uintptr_t)eventdescription);
    map.AddDouble("instance", (double)(uintptr_t)instance);
    map.AddDouble("userdata", (double)(uintptr_t)userdata); // ptr to userdata

    map.SendAsyncEvent();
    return FMOD_OK;
}

gms_export double fmod_studio_comreplay_set_create_instance_callback(char *ptr)
{
    double ret = -1;
    auto com = (FMOD::Studio::CommandReplay *)ptr;
    
    if (com && com->isValid())
    {
         check = com->setCreateInstanceCallback(
                (FMOD_STUDIO_COMMANDREPLAY_CREATE_INSTANCE_CALLBACK)fmod_studio_comreplay_create_instance_callback);

         if (check == FMOD_OK) ret = 0;
    }

    return ret;
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

gms_export double fmod_studio_comreplay_set_frame_callback(char *ptr)
{
    double ret = -1;
    auto com = (FMOD::Studio::CommandReplay *)ptr;

    if (com && com->isValid())
    {
        check = com->setFrameCallback(
            (FMOD_STUDIO_COMMANDREPLAY_FRAME_CALLBACK)fmod_studio_comreplay_frame_callback);

        if (check == FMOD_OK) ret = 0;
    }

    return ret;
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

gms_export double fmod_studio_comreplay_set_load_bank_callback(char *ptr)
{
    double ret = -1;
    auto com = (FMOD::Studio::CommandReplay *)ptr;

    if (com && com->isValid())
    {
        check = com->setLoadBankCallback(
            (FMOD_STUDIO_COMMANDREPLAY_LOAD_BANK_CALLBACK)fmod_studio_comreplay_load_bank_callback);

        if (check == FMOD_OK) ret = 0;
    }

    return ret;
}

gms_export double fmod_studio_comreplay_start(char *ptr)
{
    double ret = -1;

    auto com = (FMOD::Studio::CommandReplay *)ptr;
    if (com && com->isValid())
    {
        check = com->start();
        if (check == FMOD_OK) ret = 0;
    }

    return ret;
}

gms_export double fmod_studio_comreplay_stop(char *ptr)
{
    double ret = -1;

    auto com = (FMOD::Studio::CommandReplay *)ptr;
    if (com && com->isValid())
    {
        check = com->stop();
        if (check == FMOD_OK) ret = 0;
    }

    return ret;
}

gms_export double fmod_studio_comreplay_get_current_command_index(char *ptr)
{
    double ret = -1;

    auto com = (FMOD::Studio::CommandReplay *)ptr;
    if (com && com->isValid())
    {
        int command;
        check = com->getCurrentCommand(&command, nullptr);
        if (check == FMOD_OK) ret = (double)command;
    }

    return ret;
}

gms_export double fmod_studio_comreplay_get_current_command_time(char *ptr)
{
    double ret = -1;

    auto com = (FMOD::Studio::CommandReplay *)ptr;
    if (com && com->isValid())
    {
        float time;
        check = com->getCurrentCommand(nullptr, &time);
        if (check == FMOD_OK) ret = (double)time;
    }

    return ret;
}

gms_export double fmod_studio_comreplay_get_playback_state(char *ptr)
{
    double ret = -1;

    auto com = (FMOD::Studio::CommandReplay *)ptr;
    if (com && com->isValid())
    {
        FMOD_STUDIO_PLAYBACK_STATE state;
        check = com->getPlaybackState(&state);
        if (check == FMOD_OK) ret = (double)state;
    }

    return ret;
}

gms_export double fmod_studio_comreplay_set_paused(char *ptr, double paused)
{
    double ret = -1;

    auto com = (FMOD::Studio::CommandReplay *)ptr;
    if (com && com->isValid())
    {
        check = com->setPaused((bool)paused);
        if (check == FMOD_OK) ret = 0;
    }

    return ret;
}

gms_export double fmod_studio_comreplay_get_paused(char *ptr)
{
    double ret = -1;

    auto com = (FMOD::Studio::CommandReplay *)ptr;
    if (com && com->isValid())
    {
        bool paused;
        check = com->getPaused(&paused);
        if (check == FMOD_OK) ret = (double)paused;
    }

    return ret;
}

gms_export double fmod_studio_comreplay_seek_to_command(char *ptr, double commandindex)
{
    double ret = -1;

    auto com = (FMOD::Studio::CommandReplay *)ptr;
    if (com && com->isValid())
    {
        check = com->seekToCommand((int)commandindex);
        if (check == FMOD_OK) ret = 0;
    }

    return ret;
}

gms_export double fmod_studio_comreplay_seek_to_time(char *ptr, double time)
{
    double ret = -1;

    auto com = (FMOD::Studio::CommandReplay *)ptr;
    if (com && com->isValid())
    {
        check = com->seekToTime((float)time);
        if (check == FMOD_OK) ret = 0;
    }

    return ret;
}

gms_export double fmod_studio_comreplay_get_command_at_time(char *ptr, double time)
{
    double ret = -1;

    auto com = (FMOD::Studio::CommandReplay *)ptr;
    if (com && com->isValid())
    {
        int command;
        check = com->getCommandAtTime((float)time, &command);
        if (check == FMOD_OK) ret = (double)command;
    }

    return ret;
}

gms_export double fmod_studio_comreplay_get_command_count(char *ptr)
{
    double ret = -1;

    auto com = (FMOD::Studio::CommandReplay *)ptr;
    if (com && com->isValid())
    {
        int count;
        check = com->getCommandCount(&count);
        if (check == FMOD_OK) ret = (double)count;
    }

    return ret;
}

gms_export double fmod_studio_comreplay_get_command_info(char *ptr, double commandindex, char *gmbuf)
{
    double ret = -1;

    auto com = (FMOD::Studio::CommandReplay *)ptr;
    if (com && com->isValid())
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
        
        if (check == FMOD_OK) ret = 0;
    }

    return ret;
}

gms_export const char *fmod_studio_comreplay_get_command_string(char *ptr, double commandindex)
{
    static std::string str;

    auto com = (FMOD::Studio::CommandReplay *)ptr;
    if (com && com->isValid())
    {
        char cstr[PATH_MAX_LENGTH];
        check = com->getCommandString((int)commandindex ,cstr , PATH_MAX_LENGTH);
        str.assign(cstr);
    }

    return str.c_str();
}

// Retrieves total playback time, or -1 on error.
gms_export double fmod_studio_comreplay_get_length(char *ptr)
{
    double ret = -1;

    auto com = (FMOD::Studio::CommandReplay *)ptr;
    if (com && com->isValid())
    {
        float time;
        check = com->getLength(&time);
        if (check == FMOD_OK) ret = (double)time;
    }

    return ret;
}

gms_export double fmod_studio_comreplay_get_system(char *ptr)
{
    double ret = 0;

    auto com = (FMOD::Studio::CommandReplay *)ptr;
    if (com && com->isValid())
    {
        FMOD::Studio::System *sys;
        check = com->getSystem(&sys);
        if (check == FMOD_OK) ret = (double)(uintptr_t)sys;
    }

    return ret;
}

// Get User data, not implemented

gms_export double fmod_studio_comreplay_is_valid(char *ptr)
{
    auto com = (FMOD::Studio::CommandReplay *)ptr;
    return com->isValid();
}

gms_export double fmod_studio_comreplay_release(char *ptr)
{
    double ret = -1;

    auto com = (FMOD::Studio::CommandReplay *)ptr;
    if (com && com->isValid())
    {
        check = com->release();
        if (check == FMOD_OK) ret = 0;
    }

    return ret;
}
