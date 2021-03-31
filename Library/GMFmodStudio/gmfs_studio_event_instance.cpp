#include "gmfs_common.h"
#include "gmfs_buffer.h"
#include <fmod_errors.h>
#include <iostream>
#include <map>

typedef FMOD::Studio::EventInstance EvInst;

struct EvInstUserData
{
    EvInstUserData() : system(nullptr), sound(nullptr) {}
    EvInstUserData(FMOD_STUDIO_SYSTEM *system, const std::string &key) : system(system), key(key), sound(nullptr) {}
    FMOD_STUDIO_SYSTEM *system;
    FMOD_SOUND         *sound;
    std::string         key;
};

std::map<uintptr_t, EvInstUserData> evinstUserData;


FMOD_RESULT CreateProgrammerSoundAudioTable(
    FMOD::Studio::EventInstance             *inst,
    const std::string                       &key, 
    FMOD::Studio::System                    *studio,
    FMOD_STUDIO_PROGRAMMER_SOUND_PROPERTIES *props)
{
    FMOD_RESULT result;
    FMOD_STUDIO_SOUND_INFO info;

    if (key == "__NAME__") // Special setting to receive the name of the programmer instrument as the key
    {
        result = studio->getSoundInfo(props->name, &info);
    }
    else
    {
        result = studio->getSoundInfo(key.c_str(), &info);
    }

    if (result != FMOD_OK)
    {
        std::cerr << "GMFMOD Callback Error while getting soundinfo: " << FMOD_ErrorString(result);
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
        std::cerr << "GMFMOD Callback Error while creating FMOD::Sound: " << FMOD_ErrorString(result);
        return result;
    }

    props->sound = (FMOD_SOUND *)sound;
    props->subsoundIndex = info.subsoundindex;

    evinstUserData[(uintptr_t)inst].sound = (FMOD_SOUND *)sound;

    return result;
}

std::string gDlsname;
gms_export void fmod_studio_set_dlsname(char *name)
{
    gDlsname = name;
}

gms_export const char *fmod_studio_get_dlsname()
{
    return gDlsname.c_str();
}

FMOD_RESULT CreateProgrammerSoundFromFile(
    FMOD::Studio::EventInstance             *inst,
    const std::string                       &filename, 
    FMOD::Studio::System                    *studio,
    FMOD_STUDIO_PROGRAMMER_SOUND_PROPERTIES *props)
{
    FMOD_RESULT result;

    FMOD::System *core;
    result = studio->getCoreSystem(&core);
    if (result != FMOD_OK)
    {
        std::cerr << "GMFMOD Callback Error while getting FMOD::System: " << FMOD_ErrorString(result);
        return result;
    }

    auto exinfo = FMOD_CREATESOUNDEXINFO();
    exinfo.cbsize = sizeof(FMOD_CREATESOUNDEXINFO);

    if (!gDlsname.empty())
    {
        exinfo.dlsname = gDlsname.c_str();
    }


    FMOD::Sound *sound;
    result = core->createSound(filename.c_str(),
        FMOD_LOOP_NORMAL | FMOD_CREATECOMPRESSEDSAMPLE | FMOD_NONBLOCKING | FMOD_ACCURATETIME,
&exinfo, &sound);
if (result != FMOD_OK)
{
    std::cerr << "GMFMOD Callback Error while creating FMOD::Sound: " << FMOD_ErrorString(result);
    return result;
}

props->sound = (FMOD_SOUND *)sound;
props->subsoundIndex = -1;

evinstUserData[(uintptr_t)inst].sound = (FMOD_SOUND *)sound;

return result;
}


// General callback handler for EventInstances
FMOD_RESULT F_CALLBACK fmod_studio_evinst_callback(
    FMOD_STUDIO_EVENT_CALLBACK_TYPE type,
    FMOD_STUDIO_EVENTINSTANCE *inst,
    void *params)
{
    GM_DsMap map;
    map.AddDouble("type", (double)type);
    map.AddDouble("event", (double)(uintptr_t)inst); // should cast to ptr on GMS side
    map.AddString("fmodCallbackType", "EventInstance");

    FMOD_RESULT result = FMOD_OK;

    switch (type)
    {
    case FMOD_STUDIO_EVENT_CALLBACK_CREATE_PROGRAMMER_SOUND:
    {
        auto props = (FMOD_STUDIO_PROGRAMMER_SOUND_PROPERTIES *)params;

        if (evinstUserData.count((uintptr_t)inst) > 0)
        {
            EvInstUserData &data = evinstUserData[(uintptr_t)inst];

            if (data.key.find('.') == std::string::npos)
            {
                result = CreateProgrammerSoundAudioTable((FMOD::Studio::EventInstance *)inst,
                    data.key, (FMOD::Studio::System *)data.system, props);
            }
            else
            {
                result = CreateProgrammerSoundFromFile((FMOD::Studio::EventInstance *)inst,
                    data.key, (FMOD::Studio::System *)data.system, props);
            }
        }

        map.AddString("name", props->name);
        map.AddDouble("sound", (double)(uintptr_t)props->sound);
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

    case FMOD_STUDIO_EVENT_CALLBACK_DESTROYED:
    {
        if (evinstUserData.count((uintptr_t)inst) > 0)
        {
            evinstUserData.erase((uintptr_t)inst);
        }
    } break;

    }

    map.SendAsyncEvent();

    return result;
}

// Only strings supported
gms_export void fmod_studio_evinst_set_user_data(char *ptr, char *userDataStr, char *studioSystem)
{
    evinstUserData[(uintptr_t)ptr] = std::move(EvInstUserData((FMOD_STUDIO_SYSTEM *)studioSystem, userDataStr));
}

gms_export const char *fmod_studio_evinst_get_user_data(char *ptr)
{
    if (evinstUserData.count((uintptr_t)ptr) > 0)
    {
        return evinstUserData[(uintptr_t)ptr].key.c_str();
    }
    else
    {
        return "";
    }
}

gms_export double fmod_studio_evinst_get_programmer_sound(char *ptr)
{
    if (evinstUserData.count((uintptr_t)ptr) > 0)
    {
        return (double)(uintptr_t)evinstUserData[(uintptr_t)ptr].sound;
    }
    else
    {
        return 0;
    }
}

gms_export void fmod_studio_evdesc_set_callback(char *ptr, double callback_mask)
{
    check = ((FMOD::Studio::EventDescription *)ptr)->setCallback(
        fmod_studio_evinst_callback,
        (FMOD_STUDIO_EVENT_CALLBACK_TYPE)callback_mask | FMOD_STUDIO_EVENT_CALLBACK_DESTROYED);
}

// ============================================================================
// Playback Control
// ============================================================================

/*
 * Event Instance Start
 */
gms_export void fmod_studio_evinst_start(char *ptr)
{
    check = ((EvInst *)ptr)->start();
}

/*
 * Event Instance Stop
 * (Untested)
 */
gms_export void fmod_studio_evinst_stop(char *ptr, double stop_mode)
{
    check = ((EvInst *)ptr)->stop(
        static_cast<FMOD_STUDIO_STOP_MODE>(stop_mode));
}

/*
 * Event Instance Get Playback State
 * Returns enum value or -1 if error.
 */
gms_export double fmod_studio_evinst_get_playback_state(char *ptr)
{
    FMOD_STUDIO_PLAYBACK_STATE state;
    check = ((EvInst *)ptr)->getPlaybackState(&state);

    return static_cast<double>(state);
}

/**
 * Event Instance Set Paused
 */
gms_export void fmod_studio_evinst_set_paused(char *ptr, double paused)
{
    check = ((EvInst *)ptr)->setPaused(static_cast<bool>(paused));
}

/**
 * Event Instance Get Paused
 * Returns true if paused, and false if not paused, or -1 if there was an error
 * retrieving this status.
 */
gms_export double fmod_studio_evinst_get_paused(char *ptr)
{
    bool paused{ false };
    check = ((EvInst *)ptr)->getPaused(&paused);
    return static_cast<double>(paused);
}

/*
 * Event Instance Trigger Cue
 * Triggers a cue on the Event Instance.
 * Returns FMOD_OK on success and other error code on error.
 */
gms_export void fmod_studio_evinst_trigger_cue(char *ptr)
{
    check = ((EvInst *)ptr)->triggerCue();
}

// ============================================================================
// Playback Properties
// ============================================================================

/*
 * Event Instance Set Pitch
 * Sets the pitch multiplier.
 */
gms_export void fmod_studio_evinst_set_pitch(char *ptr, double pitch)
{
    check = ((EvInst *)ptr)->setPitch(static_cast<float>(pitch));
}

/*
 * Event Instance Get Pitch
 * Gets the pitch multiplier.
 */
gms_export double fmod_studio_evinst_get_pitch(char *ptr)
{   
    float pitch{ };
    check = ((EvInst *)ptr)->getPitch(&pitch);

    return static_cast<double>(pitch);
}

/*
 * Event Instance Get Pitch Final Value
 * Gets the pitch multiplier.
 */
gms_export double fmod_studio_evinst_get_pitch_final(char *ptr)
{
    float pitch{ };
    check = ((EvInst *)ptr)->getPitch(nullptr, &pitch);

    return static_cast<double>(pitch);
}

/*
 * Event Instance Set Property
 * Sets the value of a built-in property
 */
gms_export void fmod_studio_evinst_set_property(char *ptr, double index, double value)
{
    check = ((EvInst *)ptr)->setProperty(
        static_cast<FMOD_STUDIO_EVENT_PROPERTY>(index), 
        static_cast<float>(value));
}

/*
 * Event Instance Get Property
 * Gets the value of a built-in property
 */
gms_export double fmod_studio_evinst_get_property(char *ptr, double index)
{
    float value{ };
    check = ((EvInst *)ptr)->getProperty(
        static_cast<FMOD_STUDIO_EVENT_PROPERTY>(index), 
        &value);

    return static_cast<double>(value);
}

/*
 * Event Instance Set Timeline Position
 */
gms_export void fmod_studio_evinst_set_timeline_position(char *ptr, double position)
{
    check = ((EvInst *)ptr)->setTimelinePosition((int)position);
}

/*
 * Event Instance Get Timeline Position in milliseconds
 * Returns the timeline position in ms or -1 on error.
 */
gms_export double fmod_studio_evinst_get_timeline_position(char *ptr, double index)
{
    int value{ -1 };
    check = ((EvInst *)ptr)->getTimelinePosition(&value);
    return static_cast<double>(value);
}

/*
 * Set the EventInstance volume scaling factor. 
 * Does not affect the volume set in FMOD Studio.
 */
gms_export void fmod_studio_evinst_set_volume(char *ptr, double volume)
{
    check = ((EvInst *)ptr)->setVolume((float)volume);
}

/*
 * Gets the EventInstance volume scaling factor. 
 * This value has no affect on the volume set in FMOD Studio, but is multiplied by it.
 * Returns volume scale on success and -1 on error.
 */
gms_export double fmod_studio_evinst_get_volume(char *ptr)
{
    float volume{ };
    check = ((EvInst *)ptr)->getVolume(&volume);

    return static_cast<double>(volume);
}

gms_export double fmod_studio_evinst_get_volume_final(char *ptr)
{
    float final{ };
    check = ((EvInst *)ptr)->getVolume(nullptr, &final);

    return static_cast<double>(final);
}

/*
 * Returns whether or not instance is virtual.
 */
gms_export double fmod_studio_evinst_is_virtual(char *ptr)
{
    bool isVirtual{ false };
    check = ((EvInst *)ptr)->isVirtual(&isVirtual);

    return static_cast<double>(isVirtual);
}

// ============================================================================
// 3D Attributes
// ============================================================================

/* 
 * Set 3D Attributes
 */
gms_export void fmod_studio_evinst_set_3D_attributes(char *ptr, char *gmbuf)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;

    if (inst->isValid())            // Check that handle is valid before reading.
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
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }
}

/* 
 * Get 3D Attributes, fills passed buffer with info
 * Returns 0 on success and -1 on error
 */
gms_export void fmod_studio_evinst_get_3D_attributes(char *ptr, char *gmbuf)
{
    if (((EvInst *)ptr)->isValid())
    {
        FMOD_3D_ATTRIBUTES attr;
        check = ((EvInst *)ptr)->get3DAttributes(&attr);
        
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
        }
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }
}

// Sets the listener mask. Default selects all masks. Use bit shifting to set.
// Use only if you want particular listners involved with this event 
// instance. E.g. in a multiplayer game where certain interface/musical sounds
// are "private" to a particular player.
gms_export void fmod_studio_evinst_set_listener_mask(char *ptr, double mask)
{
    check = ((EvInst *)ptr)->setListenerMask((unsigned int)mask);
}

gms_export double fmod_studio_evinst_get_listener_mask(char *ptr)
{
    unsigned int mask{ };
    check = ((EvInst *)ptr)->getListenerMask(&mask);
    return static_cast<double>(mask);
}

// ============================================================================
// Parameters
// ============================================================================

gms_export void fmod_studio_evinst_set_parameter_by_name(char *ptr, char *name, double value, double ignoreseekspeed)
{
    check = ((EvInst *)ptr)->setParameterByName(name, (float)value, (bool)ignoreseekspeed);
}

gms_export double fmod_studio_evinst_get_parameter_by_name(char *ptr, char *name)
{
    float value{ };
    check = ((EvInst *)ptr)->getParameterByName(name, &value, nullptr);
    return static_cast<double>(value);
}

gms_export double fmod_studio_evinst_get_parameter_by_name_final(char *ptr, char *name)
{

    float value{ };
    check = ((EvInst *)ptr)->getParameterByName(name, nullptr, &value);
    return value;
}

gms_export void fmod_studio_evinst_set_parameter_by_id(char *ptr, char *gmbuf, double value, double ignoreseekspeed)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;

    if (((EvInst *)ptr)->isValid())
    {
        Buffer buf(gmbuf);
        FMOD_STUDIO_PARAMETER_ID id{
            buf.read<uint32_t>(),
            buf.read<uint32_t>()
        };

        check = ((EvInst *)ptr)->setParameterByID(
            id, 
            static_cast<float>(value), 
            static_cast<bool>(ignoreseekspeed));
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }
}

// Set Parameters by IDs
// Buffer from GameMaker must be configured in packets of:
// {uin32_t, uint32_t, float} for each set of ParameterID & value.
//
gms_export void fmod_studio_evinst_set_parameters_by_ids(
    char *ptr, char *gmbuf, double count, double ignoreseekspeed)
{
    auto inst = (FMOD::Studio::EventInstance *)ptr;

    if (((EvInst *)ptr)->isValid())
    {
        // Populate arrays with contents from the buffer
        Buffer buf(gmbuf);
        FMOD_STUDIO_PARAMETER_ID *ids = new FMOD_STUDIO_PARAMETER_ID[(int)count];
        float *values = new float[(int)count];

        for (int i = 0; i < (int)count; ++i)
        {
            ids[i] = { buf.read<uint32_t>(), buf.read<uint32_t>() };
            values[i] = buf.read<float>();
        }

        // Set params
        check = ((EvInst *)ptr)->setParametersByIDs(ids, values, (int)count, (bool)ignoreseekspeed);

        // Clean up
        delete[] ids;
        delete[] values;
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }
}

gms_export double fmod_studio_evinst_get_parameter_by_id(char *ptr, char *gmbuf)
{
    if (((EvInst *)ptr)->isValid())
    {
        Buffer buf(gmbuf);
        FMOD_STUDIO_PARAMETER_ID id;
        id.data1 = buf.read<uint32_t>();
        id.data2 = buf.read<uint32_t>();

        float value = 0;
        check = ((EvInst *)ptr)->getParameterByID(id, &value, nullptr);

        return static_cast<double>(value);
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
        return 0;
    }
}

gms_export double fmod_studio_evinst_get_parameter_by_id_final(char *ptr, char *gmbuf)
{
    if (((EvInst *)ptr)->isValid())
    {
        Buffer buf(gmbuf);
        FMOD_STUDIO_PARAMETER_ID id;
        id.data1 = buf.read<uint32_t>();
        id.data2 = buf.read<uint32_t>();

        float value = 0;
        check = ((EvInst *)ptr)->getParameterByID(id, nullptr, &value);

        return static_cast<double>(value);
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
        return 0;
    }
}

// ============================================================================
// Core
// ============================================================================

// Returns channel group ptr as double, or nullptr as 0 on error
gms_export double fmod_studio_evinst_get_channel_group(char *ptr)
{
    FMOD::ChannelGroup *group = nullptr;
    check = ((EvInst *)ptr)->getChannelGroup(&group);

    return (double)(uintptr_t)group;
}

// Sets the core reverb level. Returns 0 on success and -1 on error.
gms_export void fmod_studio_evinst_set_reverb_level(char *ptr, double index, double level)
{
    check = ((EvInst *)ptr)->setReverbLevel((int)index, (float)level);
}

// Gets the core reverb level. Returns level on success and -1 on error.
gms_export double fmod_studio_evinst_get_reverb_level(char *ptr, double index)
{
    float level{ };
    check = ((EvInst *)ptr)->getReverbLevel((int)index, &level);

    return static_cast<double>(level);
}

// Gets cpu time spent processing this unit during last update.
// Returns time as microseconds on success and -1 on error.
gms_export double fmod_studio_evinst_get_cpu_usage_exclusive(char *ptr)
{
    unsigned int microsecs, nothing;
    check = ((EvInst *)ptr)->getCPUUsage(&microsecs, &nothing);

    return static_cast<double>(microsecs);
}

// Gets cpu time spent processing this unit and all of its input during the last update.
// Returns time as microseconds on success and -1 on error.
gms_export double fmod_studio_evinst_get_cpu_usage_inclusive(char *ptr)
{
    unsigned int microsecs, nothing;
    check = ((EvInst *)ptr)->getCPUUsage(&nothing, &microsecs);

    return static_cast<double>(microsecs);
}

// Fills buffer with retrieved memory usage. Returns 0 on success and -1 on error.
gms_export void fmod_studio_evinst_get_memory_usage(char *ptr, char *gmbuf)
{
    if (((EvInst *)ptr)->isValid())
    {
        Buffer buf(gmbuf);

        FMOD_STUDIO_MEMORY_USAGE usage;
        check = ((EvInst *)ptr)->getMemoryUsage(&usage);
        
        if (check == FMOD_OK)
        {
            buf.write<int32_t>(usage.exclusive);
            buf.write<int32_t>(usage.inclusive);
            buf.write<int32_t>(usage.sampledata);
        } 
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }
}

gms_export void fmod_studio_evinst_set_callback(char *ptr, double flags)
{
    check = ((EvInst *)ptr)->setCallback(
        (FMOD_STUDIO_EVENT_CALLBACK)fmod_studio_evinst_callback,
        (FMOD_STUDIO_EVENT_CALLBACK_TYPE)flags);
}

/*
 * Event Instance Release
 */
gms_export void fmod_studio_evinst_release(char *ptr)
{
    check = ((EvInst *)ptr)->release();
}

/* 
 * Checks for Event Instance handle validity
 */
gms_export double fmod_studio_evinst_is_valid(char *ptr)
{
    return ((EvInst *)ptr)->isValid();
}

// Returns a ptr to the event description or nullptr on error.
gms_export double fmod_studio_evinst_get_description(char *ptr)
{
    FMOD::Studio::EventDescription *desc{ nullptr };
    check = ((EvInst *)ptr)->getDescription(&desc);

    return (double)(uintptr_t)desc;
}
