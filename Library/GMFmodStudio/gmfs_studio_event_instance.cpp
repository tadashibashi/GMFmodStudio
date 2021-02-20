#include "gmfs_common.h"
#include "gmfs_buffer.h"
#include <iostream>

// Helper converts a raw double pointer to an EventDescription pointer.
#define evinst_ptr(ptr) ((FMOD::Studio::EventInstance *)(uintptr_t)ptr)

FMOD_RESULT F_CALLBACK fmod_studio_evinst_callback(
    FMOD_STUDIO_EVENT_CALLBACK_TYPE type, 
    FMOD_STUDIO_EVENTINSTANCE *inst,
    void *params)
{
    GM_DsMap map;
    map.AddDouble("type", (double)type);
    map.AddDouble("event", (double)(uintptr_t)inst); // should cast to ptr on GMS side

    switch (type)
    {
    case FMOD_STUDIO_EVENT_CALLBACK_CREATE_PROGRAMMER_SOUND:
    {
        auto props = (FMOD_STUDIO_PROGRAMMER_SOUND_PROPERTIES *)params;
        FMOD_STUDIO_PROGRAMMER_SOUND_PROPERTIES *sound;

        FMOD_Studio_EventInstance_GetUserData(inst, (void **)&sound);
        props->name = sound->name;
        props->sound = sound->sound;
        props->subsoundIndex = sound->subsoundIndex;

        map.AddString("name", sound->name);
        map.AddDouble("sound", (double)(uintptr_t)sound->sound);
        map.AddDouble("subsoundIndex", (double)sound->subsoundIndex);
    } break;
    case FMOD_STUDIO_EVENT_CALLBACK_DESTROY_PROGRAMMER_SOUND:
    {
        auto props = (FMOD_STUDIO_PROGRAMMER_SOUND_PROPERTIES *)params;

        FMOD_Sound_Release(props->sound);

        map.AddString("name", props->name);
        map.AddDouble("sound", (double)(uintptr_t)props->sound);
        map.AddDouble("subsoundIndex", (double)props->subsoundIndex);
    } break;

    case FMOD_STUDIO_EVENT_CALLBACK_PLUGIN_CREATED:
    case FMOD_STUDIO_EVENT_CALLBACK_PLUGIN_DESTROYED:
    {
        auto props = (FMOD_STUDIO_PLUGIN_INSTANCE_PROPERTIES *)params;
        map.AddString("name", props->name);
        map.AddDouble("dsp", (double)(uintptr_t)props->dsp);
    } break;

    case FMOD_STUDIO_EVENT_CALLBACK_TIMELINE_MARKER:
    {
        auto props = (FMOD_STUDIO_TIMELINE_MARKER_PROPERTIES *)params;
        map.AddString("name", props->name);
        map.AddDouble("position", (double)props->position);
    } break;

    case FMOD_STUDIO_EVENT_CALLBACK_TIMELINE_BEAT:
    {
        auto props = (FMOD_STUDIO_TIMELINE_BEAT_PROPERTIES *)params;
        map.AddDouble("bar", (double)props->bar); // starting from 1
        map.AddDouble("beat", (double)props->beat); // starting from 1
        map.AddDouble("position", (double)props->position); // ms
        map.AddDouble("tempo", (double)props->tempo); // bpm
        map.AddDouble("timesignatureupper", (double)props->timesignatureupper);
        map.AddDouble("timesignaturelower", (double)props->timesignaturelower);
    } break;

    case FMOD_STUDIO_EVENT_CALLBACK_SOUND_PLAYED:
    case FMOD_STUDIO_EVENT_CALLBACK_SOUND_STOPPED:
    {
        map.AddDouble("sound", (double)(uintptr_t)params);
    } break;

    }

    map.SendAsyncEvent();

    return FMOD_OK;
}

// ============================================================================
// Playback Control
// ============================================================================

/*
 * Event Instance Start
 * Returns 0 success and -1 on failure
 */
gms_export double fmod_studio_evinst_start(char *ptr)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double success = -1;

    if (inst && inst->isValid())
    {
        check = inst->start();
        if (check == FMOD_OK)
            success = 0;
    }

    return success;
}

/*
 * Event Instance Stop
 * (Untested)
 */
gms_export double fmod_studio_evinst_stop(char *ptr, double stop_mode)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double success = -1;

    if (inst && inst->isValid())
    {
        check = inst->stop(static_cast<FMOD_STUDIO_STOP_MODE>(stop_mode));

        if (check == FMOD_OK) success = 0;
    }

    return success;
}

/*
 * Event Instance Get Playback State
 * Returns enum value or -1 if error.
 */
gms_export double fmod_studio_evinst_get_playback_state(char *ptr)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret = -1;

    if (inst && inst->isValid())
    {
        FMOD_STUDIO_PLAYBACK_STATE state;
        check = inst->getPlaybackState(&state);

        if (check == FMOD_OK) ret = (double)state;
    }

    return ret;
}

/**
 * Event Instance Set Paused
 */
gms_export double fmod_studio_evinst_set_paused(char *ptr, double paused)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double success = -1;

    if (inst && inst->isValid())
    {
        check = inst->setPaused(static_cast<bool>(paused));

        if (check == FMOD_OK) success = 0;
    }

    return success;
}

/**
 * Event Instance Get Paused
 * Returns true if paused, and false if not paused, or -1 if there was an error
 * retrieving this status.
 */
gms_export double fmod_studio_evinst_get_paused(char *ptr)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret = -1;

    if (inst && inst->isValid())
    {
        bool paused;
        check = inst->getPaused(&paused);

        if (check == FMOD_OK) ret = static_cast<double>(paused);
    }

    return ret;
}

/*
 * Event Instance Trigger Cue
 * Triggers a cue on the Event Instance.
 * Returns 0 on success and -1 on failure.
 */
gms_export double fmod_studio_evinst_trigger_cue(char *ptr)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double success = -1;

    if (inst && inst->isValid())
    {
        check = inst->triggerCue();

        if (check == FMOD_OK) success = 0;
    }

    return success;
}

// ============================================================================
// Playback Properties
// ============================================================================

/*
 * Event Instance Set Pitch
 * Sets the pitch multiplier.
 * Returns 0 on success and -1 on failure.
 */
gms_export double fmod_studio_evinst_set_pitch(char *ptr, double pitch)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double success = -1;

    if (inst && inst->isValid())
    {
        check = inst->setPitch(static_cast<float>(pitch));

        if (check == FMOD_OK) success = 0;
    }

    return success;
}

/*
 * Event Instance Get Pitch
 * Gets the pitch multiplier.
 */
gms_export double fmod_studio_evinst_get_pitch(char *ptr)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret{ 0 };
    
    if (inst && inst->isValid())
    {
        float pitch;
        check = inst->getPitch(&pitch);

        if (check == FMOD_OK) ret = static_cast<double>(pitch);
    }

    return ret;
}

/*
 * Event Instance Get Pitch Final Value
 * Gets the pitch multiplier.
 */
gms_export double fmod_studio_evinst_get_pitch_final(char *ptr)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret{ 0 };
    
    if (inst && inst->isValid())
    {
        float pitch;
        check = inst->getPitch(nullptr, &pitch);

        if (check == FMOD_OK) ret = static_cast<double>(pitch);
    }

    return ret;
}

/*
 * Event Instance Set Property
 * Sets the value of a built-in property
 * 
 * Returns 0 on success and -1 on error.
 */
gms_export double fmod_studio_evinst_set_property(char *ptr, double index, double value)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret{ -1 };

    if (inst && inst->isValid())
    {
        check = inst->setProperty(
            static_cast<FMOD_STUDIO_EVENT_PROPERTY>(index), 
            static_cast<float>(value));

        if (check == FMOD_OK) ret = 0;
    }

    return ret;
}

/*
 * Event Instance Get Property
 * Gets the value of a built-in property
 */
gms_export double fmod_studio_evinst_get_property(char *ptr, double index)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret{ 0 };

    if (inst && inst->isValid())
    {
        float value;
        check = inst->getProperty(
            static_cast<FMOD_STUDIO_EVENT_PROPERTY>(index), 
            &value);

        if (check == FMOD_OK) ret = value;
    }

    return ret;
}

/*
 * Event Instance Set Timeline Position
 * Gets the value of a built-in property
 * Returns 0 on success and -1 on error.
 */
gms_export double fmod_studio_evinst_set_timeline_position(char *ptr, double position)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret{ -1 };

    if (inst && inst->isValid())
    {
        check = inst->setTimelinePosition((int)position);

        if (check == FMOD_OK) ret = 0;
    }

    return ret;
}

/*
 * Event Instance Get Timeline Position in milliseconds
 * Returns the timeline position in ms or -1 on error.
 */
gms_export double fmod_studio_evinst_get_timeline_position(char *ptr, double index)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret{ -1 };

    if (inst && inst->isValid())
    {
        int value;
        check = inst->getTimelinePosition(&value);

        if (check == FMOD_OK) ret = value;
    }

    return ret;
}

/*
 * Set the EventInstance volume scaling factor. 
 * Does not affect the volume set in FMOD Studio.
 * Returns 0 on success and -1 on error.
 */
gms_export double fmod_studio_evinst_set_volume(char *ptr, double volume)
{
    double ret = -1;
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    if (inst && inst->isValid())
    {
        check = inst->setVolume((float)volume);

        if (check == FMOD_OK) ret = 0;
    }

    return ret;
}

/*
 * Gets the EventInstance volume scaling factor. 
 * This value has no affect on the volume set in FMOD Studio, but is multiplied by it.
 * Returns volume scale on success and -1 on error.
 */
gms_export double fmod_studio_evinst_get_volume(char *ptr)
{
    double ret = -1;
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    if (inst && inst->isValid())
    {
        float volume;
        check = inst->getVolume(&volume);

        if (check == FMOD_OK) ret = (double)volume;
    }

    return ret;
}

/*
 * Returns whether or not instance is virtual, or -1 on error.
 */
gms_export double fmod_studio_evinst_is_virtual(char *ptr)
{
    double ret = -1;

    auto inst = (FMOD::Studio::EventInstance *)ptr;
    if (inst && inst->isValid())
    {
        bool isVirtual;
        check = inst->isVirtual(&isVirtual);

        if (check == FMOD_OK) ret = (double)isVirtual;
    }

    return ret;
}

// ============================================================================
// 3D Attributes
// ============================================================================

/* 
 * Set 3D Attributes
 * Returns 0 on success and -1 on error
 */
gms_export double fmod_studio_evinst_set_3D_attributes(char *ptr, char *gmbuf)
{
    double ret = -1;
    auto inst = (FMOD::Studio::EventInstance *)ptr;

    if (inst && inst->isValid())
    {
        // Retrieve the 3D Attributes info from the buffer
        Buffer buf(gmbuf);
        FMOD_3D_ATTRIBUTES attr = { 
            {
                buf.read<float>(),
                buf.read<float>(),
                buf.read<float>(),
            },            
            {
                buf.read<float>(),
                buf.read<float>(),
                buf.read<float>(),
            },            
            {
                buf.read<float>(),
                buf.read<float>(),
                buf.read<float>(),
            },            
            {
                buf.read<float>(),
                buf.read<float>(),
                buf.read<float>(),
            },

        };

        // Set attributes and check
        check = inst->set3DAttributes(&attr);
        if (check == FMOD_OK) ret = 0;
    }

    return ret;
}

/* 
 * Get 3D Attributes, fills passed buffer with info
 * Returns 0 on success and -1 on error
 */
gms_export double fmod_studio_evinst_get_3D_attributes(char *ptr, char *gmbuf)
{
    double ret = -1;
    auto inst = (FMOD::Studio::EventInstance *)ptr;

    if (inst && inst->isValid())
    {
        FMOD_3D_ATTRIBUTES attr;
        check = inst->get3DAttributes(&attr);
        
        if (check == FMOD_OK)
        {
            Buffer buf(gmbuf);            
            buf.write(attr.position.x);
            buf.write(attr.position.y);
            buf.write(attr.position.z);
            buf.write(attr.velocity.x);
            buf.write(attr.velocity.y);
            buf.write(attr.velocity.z);
            buf.write(attr.forward.x);
            buf.write(attr.forward.y);
            buf.write(attr.forward.z);
            buf.write(attr.up.x);
            buf.write(attr.up.y);
            buf.write(attr.up.z);   

            ret = 0;
        }
    }

    return ret;
}

gms_export double fmod_studio_evinst_set_callback(char *ptr, double flags)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret = -1;
    if (inst && inst->isValid())
    {
        check = inst->setCallback(
            (FMOD_STUDIO_EVENT_CALLBACK)fmod_studio_evinst_callback,
            (FMOD_STUDIO_EVENT_CALLBACK_TYPE)flags);
        
        if (check == FMOD_OK) ret = flags;
    }

    return ret;
}

/*
 * Event Instance Release
 * Returns 0 on success and -1 on failure
 */
gms_export double fmod_studio_evinst_release(char *ptr)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double success = -1;

    if (inst && inst->isValid())
    {
        check = inst->release();
        if (check == FMOD_OK)
            success = 0;
    }

    return success;
}

/* 
 * Checks for Event Instance handle validity
 */
gms_export double fmod_studio_evinst_is_valid(char *ptr)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    return inst->isValid();
}
