#include "gmfs_common.h"
#include "gmfs_buffer.h"
#include <iostream>

// Helper converts a raw double pointer to an EventDescription pointer.
#define evinst_ptr(ptr) ((FMOD::Studio::EventInstance *)(uintptr_t)ptr)

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
 */
gms_export double fmod_studio_evinst_set_3D_attributes(char *ptr, char *gmbuf)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;

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
