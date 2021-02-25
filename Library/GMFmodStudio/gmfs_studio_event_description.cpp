#include "gmfs_common.h"
#include "gmfs_buffer.h"
#include <iostream>

// ============================================================================
// Instances
// ============================================================================

/*
 * Create Event Instance
 * Returns the event instance ptr or NULL if there was a problem creating it.
 */
gms_export double fmod_studio_evdesc_create_instance(char *evt_ptr)
{
    // The event instance ptr to return
    double ret = 0;

    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    if (desc && desc->isValid())
    {
        FMOD::Studio::EventInstance *inst;
        check = desc->createInstance(&inst);

        if (check == FMOD_OK)
            ret = (double)(uintptr_t)inst;
    }
    
    return ret;
}

/*
 * Get Instance Count. 
 * Returns -1 if the event description pointer is not a valid event description pointer.
 */
gms_export double fmod_studio_evdesc_get_instance_count(char *evt_ptr)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;

    if (desc && desc->isValid())
    {
        int instance_count;
        check = desc->getInstanceCount(&instance_count);

        return static_cast<double>(instance_count);
    }
    else
    {
        return -1;
    }
}

// Fills a buffer with an array of all the events instances as ptrs cast to uint64.
// Slow because of dynamic memory allocation.
// Returns count written on success and -1 on error.
gms_export double fmod_studio_evdesc_get_instance_list(char *evt_ptr, double capacity, char *gmbuf)
{
    double ret = -1;
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    if (!desc || !desc->isValid()) return ret;

    int count;
    desc->getInstanceCount(&count);
    if (count > capacity)
        count = (int)capacity;

    FMOD::Studio::EventInstance **insts = new FMOD::Studio::EventInstance *[(int)count];
    check = desc->getInstanceList(insts, count, &count);

    if (check == FMOD_OK)
    {
        ret = (double)count;
        Buffer buf(gmbuf);
        for (int i = 0; i < count; ++i)
        {
            buf.write<uint64_t>((uint64_t)(uintptr_t)insts[i]);
        }
    }

    delete[] insts;
    return ret;
}

/*
 * Release All Instances. 
 * Returns true or 1 on success, and false or 0 on failure.
 */
gms_export double fmod_studio_evdesc_release_all_instances(char *evt_ptr)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    bool success = false;

    if (desc && desc->isValid())
    {
        check = desc->releaseAllInstances();

        if (check == FMOD_OK)
            success = true;
    }
    
    return static_cast<double>(success);
}

// ============================================================================
// Sample Data
// ============================================================================

/*
 * Loads all non-streaming sample data used by the event and any referenced event.
 * Returns true or 1 on success, and false or 0 on failure. This determines if 
 * the function succeeded or failed only. Sample loading happens 
 * asynchronously and must be checked via getSampleLoadingState to poll for 
 * when the data has loaded.
 */
gms_export double fmod_studio_evdesc_load_sample_data(char *evt_ptr)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    bool success = false;

    if (desc && desc->isValid())
    {
        check = desc->loadSampleData();
        if (check == FMOD_OK) success = true;
    }

    return static_cast<double>(success);
}

/*
 * Unloads all non-streaming sample data.
 * Sample data will not be unloaded until all instances of the event are released.
 * Returns true or 1 on success, and false or 0 on failure.
 */
gms_export double fmod_studio_evdesc_unload_sample_data(char *evt_ptr)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    bool success = false;

    if (desc && desc->isValid())
    {
        check = desc->unloadSampleData();
        if (check == FMOD_OK) success = true;
    }

    return static_cast<double>(success);
}

/*
 * Unloads all non-streaming sample data.
 * Sample data will not be unloaded until all instances of the event are released.
 * Returns loading state enum on success or -1 on failure.
 */
gms_export double fmod_studio_evdesc_get_sample_loading_state(char *evt_ptr)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    double ret = -1;

    if (desc && desc->isValid())
    {
        FMOD_STUDIO_LOADING_STATE state;
        check = desc->getSampleLoadingState(&state);
        if (check == FMOD_OK) ret = static_cast<double>(state);
    }

    return ret;
}


// ============================================================================
// Attributes
// ============================================================================

/*
 * Checks if the EventDescription is 3D.
 * Returns true or false or -1 on error.
 */
gms_export double fmod_studio_evdesc_is_3D(char *evt_ptr)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    double ret = -1;

    if (desc && desc->isValid())
    {
        bool is3D;
        check = desc->is3D(&is3D);
        if (check == FMOD_OK)
            ret = static_cast<double>(is3D);
    }

    return ret;
}

/*
 * Checks if the EventDescription is a oneshot.
 * Returns true or false or -1 on error.
 */
gms_export double fmod_studio_evdesc_is_oneshot(char *evt_ptr)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    double ret = -1;

    if (desc && desc->isValid())
    {
        bool isOneshot;
        check = desc->isOneshot(&isOneshot);
        if (check == FMOD_OK)
            ret = static_cast<double>(isOneshot);
    }

    return ret;
}

/*
 * Checks if the EventDescription is a snapshot.
 * Returns true or false or -1 on error.
 */
gms_export double fmod_studio_evdesc_is_snapshot(char *evt_ptr)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    double ret = -1;

    if (desc && desc->isValid())
    {
        bool isSnapshot;
        check = desc->isSnapshot(&isSnapshot);
        if (check == FMOD_OK)
            ret = static_cast<double>(isSnapshot);
    }

    return ret;
}

/*
 * Checks if the EventDescription is a stream.
 * Returns true or false or -1 on error.
 */
gms_export double fmod_studio_evdesc_is_stream(char *evt_ptr)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    double ret = -1;

    if (desc && desc->isValid())
    {
        bool isStream;
        check = desc->isStream(&isStream);
        if (check == FMOD_OK)
            ret = static_cast<double>(isStream);
    }

    return ret;
}

/*
 * Checks if the EventDescription has any sustain points.
 * Returns true or false or -1 on error.
 */
gms_export double fmod_studio_evdesc_has_cue(char *evt_ptr)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    double ret = -1;

    if (desc && desc->isValid())
    {
        bool hasCue;
        check = desc->hasCue(&hasCue);
        if (check == FMOD_OK)
            ret = static_cast<double>(hasCue);
    }

    return ret;
}

/*
 * Get the EventDescription's maximum distance for 3D attenuation.
 * Returns maximum distance or -1 on error.
 */
gms_export double fmod_studio_evdesc_get_max_distance(char *evt_ptr)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    double ret = -1;

    if (desc && desc->isValid())
    {
        float maxdist;
        check = desc->getMaximumDistance(&maxdist);
        if (check == FMOD_OK)
            ret = static_cast<double>(maxdist);
    }

    return ret;
}

/*
 * Get the EventDescription's minimum distance for 3D attenuation.
 * Returns minimum distance or -1 on error.
 */
gms_export double fmod_studio_evdesc_get_min_distance(char *evt_ptr)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    double ret = -1;

    if (desc && desc->isValid())
    {
        float mindist;
        check = desc->getMinimumDistance(&mindist);
        if (check == FMOD_OK)
            ret = static_cast<double>(mindist);
    }

    return ret;
}

/*
 * Retrieves the sound size for 3D panning.
 * Retrieves the largest Sound Size value of all Spatializers and 3D Object
 * Spatializers on the event's master track. Returns zero if there are no 
 * Spatializers or 3D Object Spatializers.
 * Returns sound size or -1 on error.
 */
gms_export double fmod_studio_evdesc_get_sound_size(char *evt_ptr)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    double ret = -1;

    if (desc && desc->isValid())
    {
        float size;
        check = desc->getSoundSize(&size);
        if (check == FMOD_OK)
            ret = static_cast<double>(size);
    }

    return ret;
}

// ============================================================================
// Parameters
// ============================================================================

gms_export double fmod_studio_evdesc_get_paramdesc_count(char *evt_ptr)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    int ret = -1;

    if (desc && desc->isValid())
    {
        int count;
        check = desc->getParameterDescriptionCount(&count);
        if (check == FMOD_OK)
        {
            ret = count;
        }
    }

    return static_cast<double>(ret);
}


// Fills a gm buffer with information for a parameter description.
// Returns 0 on success and -1 on error.
gms_export double fmod_studio_evdesc_get_paramdesc_by_name(char *evt_ptr, char *name, char *buf_address)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    double ret = -1;

    if (desc && desc->isValid())
    {
        FMOD_STUDIO_PARAMETER_DESCRIPTION param;
        check = desc->getParameterDescriptionByName(name, &param);
        if (check == FMOD_OK)
        {
            Buffer buf(buf_address);
            buf.write_char_star(param.name);
            buf.write<uint32_t>(param.id.data1);
            buf.write<uint32_t>(param.id.data2);
            buf.write(param.minimum);
            buf.write(param.maximum);
            buf.write(param.defaultvalue);
            buf.write<uint32_t>(param.type);
            buf.write<uint32_t>(param.flags);

            ret = 0;
        }
    }

    return ret;
}



// Fills a gm buffer with information for a parameter description.
// Returns 0 on success and -1 on error.
gms_export double fmod_studio_evdesc_get_paramdesc_by_index(char *evt_ptr, double index, char *buf_address)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    double ret = -1;

    if (desc && desc->isValid())
    {
        FMOD_STUDIO_PARAMETER_DESCRIPTION param;
        check = desc->getParameterDescriptionByIndex(static_cast<int>(index), &param);
        if (check == FMOD_OK)
        {
            Buffer buf(buf_address);
            buf.write_char_star(param.name);
            buf.write<uint32_t>(param.id.data1);
            buf.write<uint32_t>(param.id.data2);
            buf.write(param.minimum);
            buf.write(param.maximum);
            buf.write(param.defaultvalue);
            buf.write<uint32_t>(param.type);
            buf.write<uint32_t>(param.flags);

            ret = 0;
        }
    }

    return ret;
}

// Fills a gm buffer with information for a parameter description.
// Returns 0 on success and -1 on error.
gms_export double fmod_studio_evdesc_get_paramdesc_by_id(char *evt_ptr, char *buf_address)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    double ret = -1;

    if (desc && desc->isValid())
    {
        Buffer buf(buf_address);
        FMOD_STUDIO_PARAMETER_ID id;

        id.data1 = buf.read<uint32_t>();
        id.data2 = buf.read<uint32_t>();

        FMOD_STUDIO_PARAMETER_DESCRIPTION param;
        check = desc->getParameterDescriptionByID(id, &param);

        if (check == FMOD_OK)
        {
            buf.goto_start();
            buf.write_char_star(param.name);
            buf.write<uint32_t>(param.id.data1);
            buf.write<uint32_t>(param.id.data2);
            buf.write(param.minimum);
            buf.write(param.maximum);
            buf.write(param.defaultvalue);
            buf.write<uint32_t>(param.type);
            buf.write<uint32_t>(param.flags);

            ret = 0;
        }
    }

    return ret;
}



// ============================================================================
// User Properties
// ============================================================================

/*
 * Retrieves the data of the user property.
 * Returns 0 on success and -1 on error.
 */
gms_export double fmod_studio_evdesc_get_user_property(char *evt_ptr, const char *name, char *gmbuf)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    double ret = -1;
    
    if (desc && desc->isValid())
    {
        FMOD_STUDIO_USER_PROPERTY prop;
        check = desc->getUserProperty(name, &prop);
        if (check == FMOD_OK)
        {
            ret = 0;

            Buffer buf(gmbuf);
            buf.write_char_star(prop.name);
            buf.write((uint32_t)prop.type);
            switch (prop.type)
            {
            case FMOD_STUDIO_USER_PROPERTY_TYPE_BOOLEAN:
                buf.write<int8_t>(prop.boolvalue);
                break;
            case FMOD_STUDIO_USER_PROPERTY_TYPE_FLOAT:
                buf.write(prop.floatvalue);
                break;
            case FMOD_STUDIO_USER_PROPERTY_TYPE_INTEGER:
                buf.write<int32_t>(prop.intvalue);
                break;
            case FMOD_STUDIO_USER_PROPERTY_TYPE_STRING:
                buf.write_char_star(prop.stringvalue);
                break;
            default:
                std::cerr << "Tried to get the value of user property \"" << prop.name << 
                    ", but the type of property was not supported.\n";
                break;
            }
        }
    }

    return ret;
}

/*
 * Retrieves the data of the user property at the indicated index.
 * Returns 0 on success and -1 on error.
 */
gms_export double fmod_studio_evdesc_get_user_property_by_index(char *evt_ptr, double index, char *gmbuf)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    double ret = -1;

    if (desc && desc->isValid())
    {
        FMOD_STUDIO_USER_PROPERTY prop;
        check = desc->getUserPropertyByIndex(static_cast<int>(index), &prop);
        if (check == FMOD_OK)
        {
            ret = 0;

            Buffer buf(gmbuf);
            buf.write_char_star(prop.name);
            buf.write((uint32_t)prop.type);
            switch (prop.type)
            {
            case FMOD_STUDIO_USER_PROPERTY_TYPE_BOOLEAN:
                buf.write<int8_t>(prop.boolvalue);
                break;
            case FMOD_STUDIO_USER_PROPERTY_TYPE_FLOAT:
                buf.write(prop.floatvalue);
                break;
            case FMOD_STUDIO_USER_PROPERTY_TYPE_INTEGER:
                buf.write<int32_t>(prop.intvalue);
                break;
            case FMOD_STUDIO_USER_PROPERTY_TYPE_STRING:
                buf.write_char_star(prop.stringvalue);
                break;
            default:
                std::cerr << "Tried to get the value of user property \"" << prop.name << 
                    ", but the type of property was not supported.\n";
                break;
            }
        }
    }

    return ret;
}

/*
 * Retrieves the number of user properties attached to an event description.
 * Returns the number of properties or -1 on error.
 */
gms_export double fmod_studio_evdesc_get_user_property_count(char *evt_ptr)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    double ret = -1;

    if (desc && desc->isValid())
    {
        int count;
        check = desc->getUserPropertyCount(&count);
        if (check == FMOD_OK)
            ret = static_cast<double>(count);
    }

    return ret;
}

// ============================================================================
// General
// ============================================================================

gms_export double fmod_studio_evdesc_get_id(char *evt_ptr, char *gm_buf)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    auto buffer = Buffer(gm_buf);

    double ret = -1;

    if (desc && desc->isValid())
    {
        FMOD_GUID id;
        check = desc->getID(&id);
        if (check == FMOD_OK)
        {
            ret = 0;

            buffer.write<uint32_t>(id.Data1);
            buffer.write<uint16_t>(id.Data2);
            buffer.write<uint16_t>(id.Data3);

            for (int i = 0; i < 8; ++i)
            {
                buffer.write<uint8_t>(id.Data4[i]);
            }
        }
    }

    return ret;
}

/*
 * Gets the length of the EventDescription in milliseconds.
 * Returns length or -1 on error.
 */
gms_export double fmod_studio_evdesc_get_length(char *evt_ptr)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    double ret = -1;

    if (desc && desc->isValid())
    {
        int length;
        check = desc->getLength(&length);
        if (check == FMOD_OK)
        {
            ret = static_cast<double>(length);
        }
    }

    return ret;
}

/*
 * Gets the path of the EventDescription.
 * Returns path or nullptr on error.
 */
gms_export char *fmod_studio_evdesc_get_path(char *evt_ptr)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    static std::string ret;

    if (desc && desc->isValid())
    {
        char path[100];
        check = desc->getPath(path, 100, nullptr);
        if (check == FMOD_OK)
        {
            ret.assign(path);
        }
    }

    return const_cast<char *>(ret.c_str());
}

/*
 * Checks if the EventDescription reference is valid.
 * Returns true or false.
 */
gms_export double fmod_studio_evdesc_is_valid(char *evt_ptr)
{
    auto desc = (FMOD::Studio::EventDescription *)evt_ptr;
    return (desc && desc->isValid());
}

