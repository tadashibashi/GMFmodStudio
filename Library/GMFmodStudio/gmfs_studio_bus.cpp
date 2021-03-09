#include "gmfs_common.h"
#include <iostream>

typedef FMOD::Studio::Bus StudioBus;

gms_export void fmod_studio_bus_set_paused(char *ptr, double paused)
{
    check = ((StudioBus *)ptr)->setPaused((bool)paused);
}

gms_export double fmod_studio_bus_get_paused(char *ptr)
{
    bool paused{ };
    check = ((StudioBus *)ptr)->getPaused(&paused);

    return static_cast<double>(paused);
}

gms_export void fmod_studio_bus_set_volume(char *ptr, double volume)
{
    check = ((StudioBus *)ptr)->setVolume((float)volume);
}

gms_export double fmod_studio_bus_get_volume(char *ptr)
{
    float volume{ };
    check = ((StudioBus *)ptr)->getVolume(&volume);

    return static_cast<double>(volume);
}

gms_export double fmod_studio_bus_get_volume_final(char *ptr)
{
    float volume{ };
    check = ((StudioBus *)ptr)->getVolume(nullptr, &volume);

    return static_cast<double>(volume);
}

gms_export void fmod_studio_bus_set_mute(char *ptr, double mute)
{
    check = ((StudioBus *)ptr)->setMute((bool)mute);
}

gms_export double fmod_studio_bus_get_mute(char *ptr)
{
    bool mute{ };
    check = ((StudioBus *)ptr)->getMute(&mute);

    return static_cast<double>(mute);
}

// Gets the underlying pointer to the core channel group, or 0 on error.
gms_export double fmod_studio_bus_get_channel_group(char *ptr)
{
    FMOD::ChannelGroup *group{ };
    check = ((StudioBus *)ptr)->getChannelGroup(&group);

    return (double)(uintptr_t)group;
}

gms_export void fmod_studio_bus_lock_channel_group(char *ptr)
{
    check = ((StudioBus *)ptr)->lockChannelGroup();
}

gms_export void fmod_studio_bus_unlock_channel_group(char *ptr)
{
    check = ((StudioBus *)ptr)->unlockChannelGroup();
}

gms_export void fmod_studio_bus_stop_all_events(char *ptr, double stop_mode)
{
    check = ((StudioBus *)ptr)->stopAllEvents(
        static_cast<FMOD_STUDIO_STOP_MODE>(stop_mode));
}

// Gets cpu time spent processing this unit during last update.
// Returns time as microseconds on success and -1 on error.
gms_export double fmod_studio_bus_get_cpu_usage_exclusive(char *ptr)
{
    unsigned int microsecs{ }, dummy;
    check = ((StudioBus *)ptr)->getCPUUsage(&microsecs, &dummy);

    return static_cast<double>(microsecs);
}

// Gets cpu time spent processing this unit and all of its input during the last update.
// Returns time as microseconds on success and -1 on error.
gms_export double fmod_studio_bus_get_cpu_usage_inclusive(char *ptr)
{
    unsigned int microsecs{ }, dummy;
    check = ((StudioBus *)ptr)->getCPUUsage(&dummy, &microsecs);

    return static_cast<double>(microsecs);
}

// Fills buffer with retrieved memory usage. Returns 0 on success and -1 on error.
gms_export void fmod_studio_bus_get_memory_usage(char *ptr, char *gmbuf)
{
    FMOD_STUDIO_MEMORY_USAGE usage{};
    check = ((StudioBus *)ptr)->getMemoryUsage(&usage);
    if (check == FMOD_OK)
    {
        Buffer buf(gmbuf);
        buf.write<int32_t>(usage.exclusive);
        buf.write<int32_t>(usage.inclusive);
        buf.write<int32_t>(usage.sampledata);
    }
}

gms_export double fmod_studio_bus_get_id(char *ptr, char *gmbuf)
{
    return fmod_studio_obj_get_id<FMOD::Studio::Bus>(ptr, gmbuf);
}

gms_export char *fmod_studio_bus_get_path(char *ptr)
{
    return fmod_studio_obj_get_path<FMOD::Studio::Bus>(ptr);
}

gms_export double fmod_studio_bus_is_valid(char *ptr)
{
    return ((StudioBus *)ptr)->isValid();
}
