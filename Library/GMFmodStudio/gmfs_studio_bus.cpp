#include "gmfs_common.h"
#include <iostream>

gms_export double fmod_studio_bus_set_paused(char *ptr, double paused)
{
    auto bus = (FMOD::Studio::Bus *)ptr;
    double ret = -1;

    if (bus && bus->isValid())
    {
        check = bus->setPaused((bool)paused);
        if (check == FMOD_OK) ret = 0;
    }

    return ret;
}

gms_export double fmod_studio_bus_get_paused(char *ptr)
{
    auto bus = (FMOD::Studio::Bus *)ptr;
    double ret = -1;

    if (bus && bus->isValid())
    {
        bool paused;
        check = bus->getPaused(&paused);

        if (check == FMOD_OK) ret = (double)paused;
    }

    return ret;
}

gms_export double fmod_studio_bus_set_volume(char *ptr, double volume)
{
    auto bus = (FMOD::Studio::Bus *)ptr;
    double ret = -1;

    if (bus && bus->isValid())
    {
        check = bus->setVolume((float)volume);
        if (check == FMOD_OK) ret = 0;
    }

    return ret;
}

gms_export double fmod_studio_bus_get_volume(char *ptr)
{
    auto bus = (FMOD::Studio::Bus *)ptr;
    double ret = -1;

    if (bus && bus->isValid())
    {
        float volume;
        check = bus->getVolume(&volume);

        if (check == FMOD_OK) ret = (double)volume;
    }

    return ret;
}

gms_export double fmod_studio_bus_set_mute(char *ptr, double mute)
{
    auto bus = (FMOD::Studio::Bus *)ptr;
    double ret = -1;

    if (bus && bus->isValid())
    {
        check = bus->setMute((bool)mute);
        if (check == FMOD_OK) ret = 0;
    }

    return ret;
}

gms_export double fmod_studio_bus_get_mute(char *ptr)
{
    auto bus = (FMOD::Studio::Bus *)ptr;
    double ret = -1;

    if (bus && bus->isValid())
    {
        bool mute;
        check = bus->getMute(&mute);

        if (check == FMOD_OK) ret = (double)mute;
    }

    return ret;
}

// Gets the underlying pointer to the core channel group, or 0 on error.
gms_export double fmod_studio_bus_get_channel_group(char *ptr)
{
    auto bus = (FMOD::Studio::Bus *)ptr;
    double ret = 0;

    if (bus && bus->isValid())
    {
        FMOD::ChannelGroup *group;
        check = bus->getChannelGroup(&group);

        if (check == FMOD_OK) ret = (double)(uintptr_t)group;
    }

    return ret;
}

gms_export double fmod_studio_bus_lock_channel_group(char *ptr)
{
    auto bus = (FMOD::Studio::Bus *)ptr;
    double ret = -1;

    if (bus && bus->isValid())
    {
        check = bus->lockChannelGroup();

        if (check == FMOD_OK) ret = 0;
    }

    return ret;
}

gms_export double fmod_studio_bus_unlock_channel_group(char *ptr)
{
    auto bus = (FMOD::Studio::Bus *)ptr;
    double ret = -1;

    if (bus && bus->isValid())
    {
        check = bus->unlockChannelGroup();

        if (check == FMOD_OK) ret = 0;
    }

    return ret;
}

gms_export double fmod_studio_bus_stop_all_events(char *ptr, double stop_mode)
{
    auto bus = (FMOD::Studio::Bus *)ptr;
    double ret = -1;

    if (bus && bus->isValid())
    {
        check = bus->stopAllEvents((FMOD_STUDIO_STOP_MODE)stop_mode);

        if (check == FMOD_OK) ret = 0;
    }

    return ret;
}

// Gets cpu time spent processing this unit during last update.
// Returns time as microseconds on success and -1 on error.
gms_export double fmod_studio_bus_get_cpu_usage_exclusive(char *ptr)
{
    auto bus = (FMOD::Studio::Bus *)ptr;
    double ret = -1;

    if (bus && bus->isValid())
    {
        unsigned int microsecs;
        check = bus->getCPUUsage(&microsecs, nullptr);

        if (check == FMOD_OK)
            ret = (double)microsecs;
    }

    return ret;
}

// Gets cpu time spent processing this unit and all of its input during the last update.
// Returns time as microseconds on success and -1 on error.
gms_export double fmod_studio_bus_get_cpu_usage_inclusive(char *ptr)
{
    auto bus = (FMOD::Studio::Bus *)ptr;
    double ret = -1;

    if (bus && bus->isValid())
    {
        unsigned int microsecs;
        check = bus->getCPUUsage(nullptr, &microsecs);

        if (check == FMOD_OK)
            ret = (double)microsecs;
    }

    return ret;
}

// Fills buffer with retrieved memory usage. Returns 0 on success and -1 on error.
gms_export double fmod_studio_bus_get_memory_usage(char *ptr, char *gmbuf)
{
    auto bus = (FMOD::Studio::Bus *)ptr;
    double ret = -1;

    if (bus && bus->isValid())
    {
        Buffer buf(gmbuf);

        FMOD_STUDIO_MEMORY_USAGE usage;
        check = bus->getMemoryUsage(&usage);

        buf.write<int32_t>(usage.exclusive);
        buf.write<int32_t>(usage.inclusive);
        buf.write<int32_t>(usage.sampledata);

        if (check == FMOD_OK)
            ret = 0;
    }

    return ret;
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
    auto bus = (FMOD::Studio::Bus *)ptr;
    return bus->isValid();
}
