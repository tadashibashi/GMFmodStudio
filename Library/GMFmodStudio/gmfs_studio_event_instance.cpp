#include "gmfs_common.h"
#include "gmfs_buffer.h"
#include <fmod_errors.h>
#include <iostream>
#include <map>

std::string dlsname;

struct SoundCallbackData
{
    std::string key;
    FMOD::Sound *sound = nullptr;
};

FMOD_RESULT F_CALLBACK fmod_studio_evinst_callback_audiotable(
    FMOD_STUDIO_EVENT_CALLBACK_TYPE type,
    FMOD_STUDIO_EVENTINSTANCE *inst,
    void *params)
{
    GM_DsMap map;
    map.AddDouble("type", (double)type);
    map.AddDouble("inst", (double)(uintptr_t)inst); // should cast to ptr on GMS side
    map.AddString("fmodCallbackType", "EventInstance");

    switch (type)
    {
    case FMOD_STUDIO_EVENT_CALLBACK_CREATE_PROGRAMMER_SOUND:
    {
        auto props = (FMOD_STUDIO_PROGRAMMER_SOUND_PROPERTIES *)params;
        FMOD::Studio::EventInstance *ins = (FMOD::Studio::EventInstance *)inst;


        
        FMOD::Studio::System *sys;
        check = ins->getUserData((void **)&sys);
        std::cout << "Getting user data: " << FMOD_ErrorString(check) << std::endl;
        
        if (!sys->isValid())
        {
            std::cout << "FMOD Studio ERROR while creating FMOD_SOUND object from programmer sound with key \""
                << props->name << "\": The FMOD::Studio::System handle was invalid." << std::endl;
            return FMOD_ERR_INVALID_HANDLE;
        }

        FMOD_STUDIO_SOUND_INFO info;
        check = sys->getSoundInfo(props->name, &info);
        std::cout << "Getting sound info for key " << props->name << ": " << FMOD_ErrorString(check) << std::endl;
        if (check != FMOD_OK)
        {
            std::cout << "FMOD Studio ERROR while creating FMOD_SOUND object from programmer sound with key \"" 
                << props->name << "\": " << FMOD_ErrorString(check) << std::endl;
            return FMOD_ERR_EVENT_NOTFOUND;
        }

        FMOD::System *core;
        check = sys->getCoreSystem(&core);
        std::cout << "Getting core system: " << FMOD_ErrorString(check) << std::endl;
        
        FMOD::Sound *sound;
        check = core->createSound(info.name_or_data, 
            FMOD_LOOP_NORMAL | FMOD_CREATECOMPRESSEDSAMPLE | FMOD_NONBLOCKING | info.mode, 
            &info.exinfo, &sound);
        std::cout << "Creating sound: " <<  FMOD_ErrorString(check) << std::endl;



        props->sound = (FMOD_SOUND *)sound;
        props->subsoundIndex = info.subsoundindex;
        
        map.AddString("name", props->name);
        map.AddDouble("sound", (double)(uintptr_t)sound);
        map.AddDouble("subsoundIndex", (double)props->subsoundIndex);
    } break;
    case FMOD_STUDIO_EVENT_CALLBACK_DESTROY_PROGRAMMER_SOUND:
    {
        auto props = (FMOD_STUDIO_PROGRAMMER_SOUND_PROPERTIES *)params;

        FMOD_Sound_Release(props->sound);

        map.AddString("name", props->name);
        map.AddDouble("sound", (double)(uintptr_t)props->sound);
        map.AddDouble("subsoundIndex", (double)props->subsoundIndex);
    } break;
    }

    map.SendAsyncEvent();

    return FMOD_OK;
}

std::map<char *, SoundCallbackData>audiotable_evdata;

// General callback handler for EventInstances
FMOD_RESULT F_CALLBACK gmfms_audiotable_event_callback(
    FMOD_STUDIO_EVENT_CALLBACK_TYPE type,
    FMOD_STUDIO_EVENTINSTANCE *inst,
    void *params)
{
    FMOD_RESULT result;
    auto props = (FMOD_STUDIO_PROGRAMMER_SOUND_PROPERTIES *)params;
    if (type == FMOD_STUDIO_EVENT_CALLBACK_CREATE_PROGRAMMER_SOUND)
    {
        FMOD::Studio::System *studio;
        result = FMOD_Studio_EventInstance_GetUserData(inst, (void **)&studio);
        if (result != FMOD_OK)
        {
            std::cerr << "gmfms audiotable callback error: " << FMOD_ErrorString(result);
            return result;
        }

        FMOD_STUDIO_SOUND_INFO info;
        result = studio->getSoundInfo(audiotable_evdata[(char *)inst].key.c_str(), &info);
        if (result != FMOD_OK)
        {
            std::cerr << "gmfms audiotable callback error, while getting soundinfo: " << FMOD_ErrorString(result);
            return result;
        }

        FMOD::System *core;
        result = studio->getCoreSystem(&core);
        if (result != FMOD_OK)
        {
            std::cerr << "gmfms audiotable callback error, while getting core system: " << FMOD_ErrorString(result);
            return result;
        }

        FMOD::Sound *sound;
        result = core->createSound(info.name_or_data,
            FMOD_LOOP_NORMAL | FMOD_CREATECOMPRESSEDSAMPLE | FMOD_NONBLOCKING | info.mode,
            &info.exinfo, &sound);
        if (result != FMOD_OK)
        {
            std::cerr << "gmfms audiotable callback error, while creating sound: " << FMOD_ErrorString(result);
            return result;
        }

        props->sound = (FMOD_SOUND *)sound;
        props->subsoundIndex = info.subsoundindex;
        
        audiotable_evdata[(char *)inst].sound = sound;
        return result;
    }
    else if (type == FMOD_STUDIO_EVENT_CALLBACK_DESTROY_PROGRAMMER_SOUND)
    {
        audiotable_evdata[(char *)inst].sound = nullptr;

        result = FMOD_Sound_Release(props->sound);
        return result;
    }
    else
    {
        std::cerr << "GMFMS Error! Please only register "
            "gmfms_create_audiotable_event_callback with the "
            "gmfms_create_audiotable_event function." << std::endl;
        return FMOD_ERR_INVALID_PARAM;
    }
    

}

gms_export double gmfms_progevent_audiotable_release(char *inst_ptr)
{
    auto inst = (FMOD::Studio::EventInstance *)inst_ptr;
    if (audiotable_evdata.count(inst_ptr) > 0)
    {
        audiotable_evdata.erase(inst_ptr);
    }

    check = inst->release();

    return (check == FMOD_OK) ? 0 : -1;
}

gms_export double gmfms_progevent_audiotable_get_sound(char *inst_ptr)
{
    double ret = 0;
    if (audiotable_evdata.count(inst_ptr) > 0)
    {
        if (audiotable_evdata[inst_ptr].sound)
            ret = (double)(uintptr_t)audiotable_evdata[inst_ptr].sound;
    }

    return ret;
}

gms_export double gmfms_progevent_audiotable_change_key(char *inst_ptr, char *new_key)
{
    if (((FMOD::Studio::EventInstance *)inst_ptr)->isValid() &&
        audiotable_evdata.count(inst_ptr) > 0)
    {
        audiotable_evdata[inst_ptr].key = new_key;
        return 0;
    }
    else
    {
        std::cerr << "ERROR failed to change key\n";
        return -1;
    }
       
    
}

// Helpers
gms_export double gmfms_audiotable_event_create(char *studio_ptr, char *key, char *event_path)
{
    auto studio = (FMOD::Studio::System *)studio_ptr;

    FMOD::Studio::EventDescription *desc;
    check = studio->getEvent(event_path, &desc);
    if (check != FMOD_OK)
    {
        std::cerr << "GMFMS Error! gmfms_create_audiotable_event, problem while getting event description: " 
            << FMOD_ErrorString(check) << '\n';
        return 0;
    }

    FMOD::Studio::EventInstance *inst;
    check = desc->createInstance(&inst);
    if (check != FMOD_OK)
    {
        std::cerr << "GMFMS Error! gmfms_create_audiotable_event, problem while creating event instance: " 
            << FMOD_ErrorString(check) << '\n';
        return 0;
    }
    
    check = inst->setCallback(gmfms_audiotable_event_callback, 
        FMOD_STUDIO_EVENT_CALLBACK_CREATE_PROGRAMMER_SOUND | FMOD_STUDIO_EVENT_CALLBACK_DESTROY_PROGRAMMER_SOUND);
    if (check != FMOD_OK)
    {
        std::cerr << "GMFMS Error! gmfms_create_audiotable_event, problem while setting callback: " 
            << FMOD_ErrorString(check) << '\n';
        inst->release(); // clean up instance
        return 0;
    }

    check = inst->setUserData((void *)studio_ptr);
    if (check != FMOD_OK)
    {
        std::cerr << "GMFMS Error! gmfms_create_audiotable_event, problem while setting userdata: "
            << FMOD_ErrorString(check) << '\n';
        inst->release(); // clean up instance
        return 0;
    }

    // good to go, set the data
    audiotable_evdata[(char *)inst].key = std::string(key);
    audiotable_evdata[(char *)inst].sound = nullptr;

    return (double)(uintptr_t)inst;
}

// General callback handler for EventInstances
FMOD_RESULT F_CALLBACK fmod_studio_evinst_callback(
    FMOD_STUDIO_EVENT_CALLBACK_TYPE type, 
    FMOD_STUDIO_EVENTINSTANCE *inst,
    void *params)
{
    GM_DsMap map;
    map.AddDouble("type", (double)type);
    map.AddDouble("inst", (double)(uintptr_t)inst); // should cast to ptr on GMS side
    map.AddString("fmodCallbackType", "EventInstance");

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

gms_export double fmod_studio_evdesc_set_callback(char *ptr, double callback_mask)
{
    auto desc = (FMOD::Studio::EventDescription *)ptr;
    double ret = -1;
    if (desc && desc->isValid())
    {
        check = desc->setCallback(fmod_studio_evinst_callback,
            (FMOD_STUDIO_EVENT_CALLBACK_TYPE)callback_mask);
        if (check == FMOD_OK) ret = 0;
    }

    return ret;
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

// Sets the listener mask. Default selects all masks. Use bit shifting to set.
// Use only if you want particular listners involved with this event 
// instance. E.g. in a multiplayer game where certain interface/musical sounds
// are "private" to a particular player.
gms_export double fmod_studio_evinst_set_listener_mask(char *ptr, double mask)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret = -1;

    if (inst && inst->isValid())
    {
        check = inst->setListenerMask((unsigned int)mask);
        if (check == FMOD_OK)
            ret = 0;
    }
    
    return ret;
}

gms_export double fmod_studio_evinst_get_listener_mask(char *ptr)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret = -1;

    if (inst && inst->isValid())
    {
        unsigned int mask;
        check = inst->getListenerMask(&mask);

        if (check == FMOD_OK)
            ret = static_cast<double>(mask);
    }

    return ret;
}

// ============================================================================
// Parameters
// ============================================================================

gms_export double fmod_studio_evinst_set_parameter_by_name(char *ptr, char *name, double value, double ignoreseekspeed)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret = -1;

    if (inst && inst->isValid())
    {
        check = inst->setParameterByName(name, (float)value, (bool)ignoreseekspeed);

        if (check == FMOD_OK)
            ret = 0;
    }

    return ret;
}

gms_export double fmod_studio_evinst_get_parameter_by_name(char *ptr, char *name)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret = -1;

    if (inst && inst->isValid())
    {
        float value;
        check = inst->getParameterByName(name, &value, nullptr);

        if (check == FMOD_OK)
            ret = static_cast<double>(value);
    }

    return ret;
}

gms_export double fmod_studio_evinst_get_parameter_by_name_final(char *ptr, char *name)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret = -1;

    if (inst && inst->isValid())
    {
        float value;
        check = inst->getParameterByName(name, nullptr, &value);

        if (check == FMOD_OK)
            ret = static_cast<double>(value);
    }

    return ret;
}

gms_export double fmod_studio_evinst_set_parameter_by_id(char *ptr, char *gmbuf, double value, double ignoreseekspeed)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret = -1;

    if (inst && inst->isValid())
    {
        Buffer buf(gmbuf);
        FMOD_STUDIO_PARAMETER_ID id;
        id.data1 = buf.read<uint32_t>();
        id.data2 = buf.read<uint32_t>();

        check = inst->setParameterByID(id, static_cast<float>(value), static_cast<bool>(ignoreseekspeed));

        if (check == FMOD_OK)
            ret = 0;
    }

    return ret;
}

// buffer must be uin32_t, uint32_t, float for each set of ParameterID + value.
gms_export double fmod_studio_evinst_set_parameters_by_ids(char *ptr, char *gmbuf, double count, double ignoreseekspeed)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret = -1;

    if (inst && inst->isValid())
    {
        Buffer buf(gmbuf);
        FMOD_STUDIO_PARAMETER_ID *ids = new FMOD_STUDIO_PARAMETER_ID[(int)count];
        float *values = new float[(int)count];

        for (int i = 0; i < (int)count; ++i)
        {
            ids[i] = { buf.read<uint32_t>(), buf.read<uint32_t>() };
            values[i] = buf.read<float>();
        }

        check = inst->setParametersByIDs(ids, values, (int)count, (bool)ignoreseekspeed);

        if (check == FMOD_OK)
            ret = 0;

        delete[] ids;
        delete[] values;
    }

    return ret;
}

gms_export double fmod_studio_evinst_get_parameter_by_id(char *ptr, char *gmbuf)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret = -1;

    if (inst && inst->isValid())
    {
        Buffer buf(gmbuf);
        FMOD_STUDIO_PARAMETER_ID id;
        id.data1 = buf.read<uint32_t>();
        id.data2 = buf.read<uint32_t>();

        float value;
        check = inst->getParameterByID(id, &value, nullptr);

        if (check == FMOD_OK)
            ret = static_cast<double>(value);
    }

    return ret;
}

gms_export double fmod_studio_evinst_get_parameter_by_id_final(char *ptr, char *gmbuf)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret = -1;

    if (inst && inst->isValid())
    {
        Buffer buf(gmbuf);
        FMOD_STUDIO_PARAMETER_ID id;
        id.data1 = buf.read<uint32_t>();
        id.data2 = buf.read<uint32_t>();

        float value;
        check = inst->getParameterByID(id, nullptr, &value);

        if (check == FMOD_OK)
            ret = static_cast<double>(value);
    }

    return ret;
}

// ============================================================================
// Core
// ============================================================================

// Returns channel group ptr as double, or nullptr as 0 on error
gms_export double fmod_studio_evinst_get_channel_group(char *ptr)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret = 0;

    if (inst && inst->isValid())
    {
        FMOD::ChannelGroup *group;
        check = inst->getChannelGroup(&group);

        if (check == FMOD_OK)
            ret = (double)(uintptr_t)group;
    }

    return ret;
}

// Sets the core reverb level. Returns 0 on success and -1 on error.
gms_export double fmod_studio_evinst_set_reverb_level(char *ptr, double index, double level)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret = -1;

    if (inst && inst->isValid())
    {
        check = inst->setReverbLevel((int)index, (float)level);

        if (check == FMOD_OK)
            ret = 0;
    }

    return ret;
}

// Gets the core reverb level. Returns level on success and -1 on error.
gms_export double fmod_studio_evinst_get_reverb_level(char *ptr, double index)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret = -1;

    if (inst && inst->isValid())
    {
        float level;
        check = inst->getReverbLevel((int)index, &level);

        if (check == FMOD_OK)
            ret = (double)level;
    }

    return ret;
}

// Gets cpu time spent processing this unit during last update.
// Returns time as microseconds on success and -1 on error.
gms_export double fmod_studio_evinst_get_cpu_usage_exclusive(char *ptr)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret = -1;

    if (inst && inst->isValid())
    {
        unsigned int microsecs;
        check = inst->getCPUUsage(&microsecs, nullptr);

        if (check == FMOD_OK)
            ret = (double)microsecs;
    }

    return ret;
}

// Gets cpu time spent processing this unit and all of its input during the last update.
// Returns time as microseconds on success and -1 on error.
gms_export double fmod_studio_evinst_get_cpu_usage_inclusive(char *ptr)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret = -1;

    if (inst && inst->isValid())
    {
        unsigned int microsecs;
        check = inst->getCPUUsage(nullptr, &microsecs);

        if (check == FMOD_OK)
            ret = (double)microsecs;
    }

    return ret;
}

// Fills buffer with retrieved memory usage. Returns 0 on success and -1 on error.
gms_export double fmod_studio_evinst_get_memory_usage(char *ptr, char *gmbuf)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret = -1;

    if (inst && inst->isValid())
    {
        Buffer buf(gmbuf);

        FMOD_STUDIO_MEMORY_USAGE usage;
        check = inst->getMemoryUsage(&usage);

        buf.write<int32_t>(usage.exclusive);
        buf.write<int32_t>(usage.inclusive);
        buf.write<int32_t>(usage.sampledata);

        if (check == FMOD_OK)
            ret = 0;
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

gms_export double fmod_studio_evinst_set_callback_audiotable(char *ptr, char *studio_ptr)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret = -1;
    if (inst && inst->isValid())
    {
        inst->setUserData(studio_ptr);

        check = inst->setCallback(
            (FMOD_STUDIO_EVENT_CALLBACK)fmod_studio_evinst_callback_audiotable,
            FMOD_STUDIO_EVENT_CALLBACK_CREATE_PROGRAMMER_SOUND | FMOD_STUDIO_EVENT_CALLBACK_DESTROY_PROGRAMMER_SOUND);
        
        if (check == FMOD_OK) ret = 0;
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

// Returns a ptr to the event description or nullptr on error.
gms_export double fmod_studio_evinst_get_description(char *ptr)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;
    double ret = 0;

    if (inst && inst->isValid())
    {
        FMOD::Studio::EventDescription *desc;

        check = inst->getDescription(&desc);
        if (check == FMOD_OK)
            ret = (double)(uintptr_t)desc;
    }

    return ret;
}