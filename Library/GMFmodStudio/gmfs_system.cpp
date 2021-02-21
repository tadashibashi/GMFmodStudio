#include "gmfs_common.h"
#include <fmod_errors.h>
#include <iostream>

gms_export double fmod_system_init(char *ptr, double maxchannels, double flags)
{
    auto sys = (FMOD::System *)ptr;
    double ret = -1;
    if (sys)
    {
        check = sys->init((int)maxchannels, (FMOD_INITFLAGS)flags, nullptr);
        ret = 0;
    }

    return ret;
}

// Plays a sound object on the specified FMOD::System
// Returns a ptr to the channel it was played on or 0 on error.
gms_export double fmod_system_play_sound(char *ptr, char *sound_ptr)
{
    auto sys = (FMOD::System *)ptr;
    double ret = 0;

    if (sys)
    {
        FMOD::Channel *channel;
        check = sys->playSound((FMOD::Sound *)sound_ptr, nullptr, false, &channel);
        if (check != FMOD_OK)
        {
            std::cout << "Failed to play FMOD::Sound: " << FMOD_ErrorString(check) << '\n';
            return ret;
        }

        ret = (double)(uintptr_t)channel;
    }

    return ret;
}

gms_export double fmod_system_create_midi_sound(char *ptr, char *name_or_data, char *dlsname, double mode)
{
    auto sys = (FMOD::System *)ptr;
    double ret = 0;
    if (sys)
    {
        FMOD_CREATESOUNDEXINFO info = FMOD_CREATESOUNDEXINFO();
        info.cbsize = sizeof(FMOD_CREATESOUNDEXINFO);
        info.dlsname = dlsname;

        FMOD::Sound *sound;
        check = sys->createStream(name_or_data, (FMOD_MODE)mode, &info, &sound);
        if (check != FMOD_OK)
        {
            std::cout << "Failed to create midi sound: " << FMOD_ErrorString(check) << std::endl;
        }
        else
        {
            std::cout << "Created the sound successfully.\n";
        }
        ret = (double)(uintptr_t)sound;
    }

    return ret;
}

gms_export double fmod_system_is_recording(char *ptr, double id)
{
    double ret = -1;
    auto sys = (FMOD::System *)ptr;
    if (sys)
    {
        bool recording;
        check = sys->isRecording((int)id, &recording);

        if (check == FMOD_OK) ret = (double)recording;
    }

    return ret;
}

gms_export double fmod_system_get_record_num_drivers(char *ptr)
{
    double ret = -1;
    auto sys = (FMOD::System *)ptr;
    if (sys)
    {
        int drivers;
        check = sys->getRecordNumDrivers(&drivers, nullptr);

        if (check == FMOD_OK) ret = (double)drivers;
    }

    return ret;
}

gms_export double fmod_system_get_record_num_drivers_connected(char *ptr)
{
    double ret = -1;
    auto sys = (FMOD::System *)ptr;
    if (sys)
    {
        int drivers;
        check = sys->getRecordNumDrivers(nullptr, &drivers);

        if (check == FMOD_OK) ret = (double)drivers;
    }

    return ret;
}

// Returns the record position in number of samples
gms_export double fmod_system_get_record_position(char *ptr, double id)
{
    double ret = -1;
    auto sys = (FMOD::System *)ptr;
    if (sys)
    {
        unsigned int pos;
        check = sys->getRecordPosition((int)id, &pos);

        if (check == FMOD_OK) ret = (double)pos;
    }

    return ret;
}

// Starts recording into the specified sound
gms_export double fmod_system_record_start(char *ptr, double id, char *sound_ptr, double looping)
{
    double ret = -1;
    auto sys = (FMOD::System *)ptr;
    if (sys)
    {
        FMOD::Sound *sound = (FMOD::Sound *)sound_ptr;
        check = sys->recordStart((int)id, sound, (bool)looping);

        if (check == FMOD_OK) ret = 0;
    }

    return ret;
}

// Returns the record position in number of samples
gms_export double fmod_system_record_stop(char *ptr, double id)
{
    double ret = -1;
    auto sys = (FMOD::System *)ptr;
    if (sys)
    {
        check = sys->recordStop((int)id);

        if (check == FMOD_OK) ret = 0;
    }

    return ret;
}

