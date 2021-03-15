#include "gmfs_common.h"
#include "gmfs_buffer.h"
#include <iostream>

typedef FMOD::Studio::EventDescription EvDesc;

// ============================================================================
// Instances
// ============================================================================

/*
 * Create Event Instance
 * Returns the event instance ptr or NULL if there was a problem creating it.
 */
gms_export double fmod_studio_evdesc_create_instance(char *ptr)
{
    FMOD::Studio::EventInstance *inst{ };
    check = ((EvDesc *)ptr)->createInstance(&inst);
    
    return (double)(uintptr_t)inst;
}

/*
 * Get Instance Count. 
 * Returns -1 if the event description pointer is not a valid event description pointer.
 */
gms_export double fmod_studio_evdesc_get_instance_count(char *ptr)
{
    int instance_count{ };
    check = ((EvDesc *)ptr)->getInstanceCount(&instance_count);

    return static_cast<double>(instance_count);
}

// Fills a buffer with an array of all the events instances as ptrs cast to uint64.
// Slow because of dynamic memory allocation.
// Returns count written on success and -1 on error.
gms_export double fmod_studio_evdesc_get_instance_list(char *ptr, double capacity, char *gmbuf)
{
    int count{ };

    if (((EvDesc *)ptr)->isValid())
    {
        check = ((EvDesc *)ptr)->getInstanceCount(&count);
        if (check != FMOD_OK) return count;

        if (count > capacity)
            count = (int)capacity;

        FMOD::Studio::EventInstance **insts = new FMOD::Studio::EventInstance *[(int)count];
        check = ((EvDesc *)ptr)->getInstanceList(insts, count, &count);

        if (check == FMOD_OK)
        {
            Buffer buf(gmbuf);
            for (int i = 0; i < count; ++i)
            {
                buf.write<uint64_t>((uint64_t)(uintptr_t)insts[i]);
            }
        }

        delete[] insts;
    }

    return static_cast<double>(count);
}

/*
 * Release All Instances. 
 * Returns true or 1 on success, and false or 0 on failure.
 */
gms_export void fmod_studio_evdesc_release_all_instances(char *ptr)
{
    check = ((EvDesc *)ptr)->releaseAllInstances();
}

// ============================================================================
// Sample Data
// ============================================================================

/*
 * Loads all non-streaming sample data used by the event and any referenced event.
 * Sample loading happens asynchronously and must be checked via 
 * getSampleLoadingState to poll for when the data has loaded.
 */
gms_export void fmod_studio_evdesc_load_sample_data(char *ptr)
{
    check = ((EvDesc *)ptr)->loadSampleData();
}

/*
 * Unloads all non-streaming sample data.
 * Sample data will not be unloaded until all instances of the event are released.
 * Returns true or 1 on success, and false or 0 on failure.
 */
gms_export void fmod_studio_evdesc_unload_sample_data(char *ptr)
{
    check = ((EvDesc *)ptr)->unloadSampleData();
}

/*
 * Unloads all non-streaming sample data.
 * Sample data will not be unloaded until all instances of the event are released.
 * Returns loading state enum on success or -1 on failure.
 */
gms_export double fmod_studio_evdesc_get_sample_loading_state(char *ptr)
{
    FMOD_STUDIO_LOADING_STATE state{ };
    check = ((EvDesc *)ptr)->getSampleLoadingState(&state);

    return static_cast<double>(state);
}


// ============================================================================
// Attributes
// ============================================================================

/*
 * Checks if the EventDescription is 3D.
 * Returns true or false or -1 on error.
 */
gms_export double fmod_studio_evdesc_is_3D(char *ptr)
{
    bool is3D{ };
    check = ((EvDesc *)ptr)->is3D(&is3D);

    return static_cast<double>(is3D);
}

/*
 * Checks if the EventDescription is a oneshot.
 * Returns true or false or -1 on error.
 */
gms_export double fmod_studio_evdesc_is_oneshot(char *ptr)
{
    bool isOneshot{ };
    check = ((EvDesc *)ptr)->isOneshot(&isOneshot);

    return static_cast<double>(isOneshot);
}

/*
 * Checks if the EventDescription is a snapshot.
 * Returns true or false or -1 on error.
 */
gms_export double fmod_studio_evdesc_is_snapshot(char *ptr)
{
    bool isSnapshot{ };
    check = ((EvDesc *)ptr)->isSnapshot(&isSnapshot);
    return static_cast<double>(isSnapshot);
}

/*
 * Checks if the EventDescription is a stream.
 * Returns true or false or -1 on error.
 */
gms_export double fmod_studio_evdesc_is_stream(char *ptr)
{
    bool isStream{ };
    check = ((EvDesc *)ptr)->isStream(&isStream);

    return static_cast<double>(isStream);
}

/*
 * Checks if the EventDescription has any sustain points.
 * Returns true or false or -1 on error.
 */
gms_export double fmod_studio_evdesc_has_cue(char *ptr)
{
    bool hasCue{ };
    check = ((EvDesc *)ptr)->hasCue(&hasCue);

    return static_cast<double>(hasCue);
}

/*
 * Get the EventDescription's maximum distance for 3D attenuation.
 * Returns maximum distance or -1 on error.
 */
gms_export double fmod_studio_evdesc_get_max_distance(char *ptr)
{
    float maxdist{ };
    check = ((EvDesc *)ptr)->getMaximumDistance(&maxdist);

    return static_cast<double>(maxdist);
}

/*
 * Get the EventDescription's minimum distance for 3D attenuation.
 * Returns minimum distance or -1 on error.
 */
gms_export double fmod_studio_evdesc_get_min_distance(char *ptr)
{
    float mindist{ };
    check = ((EvDesc *)ptr)->getMinimumDistance(&mindist);

    return static_cast<double>(mindist);
}

/*
 * Retrieves the sound size for 3D panning.
 * Retrieves the largest Sound Size value of all Spatializers and 3D Object
 * Spatializers on the event's master track. Returns zero if there are no 
 * Spatializers or 3D Object Spatializers.
 * Returns sound size or -1 on error.
 */
gms_export double fmod_studio_evdesc_get_sound_size(char *ptr)
{
    float size{ };
    check = ((EvDesc *)ptr)->getSoundSize(&size);

    return static_cast<double>(size);
}

// ============================================================================
// Parameters
// ============================================================================

gms_export double fmod_studio_evdesc_get_paramdesc_count(char *ptr)
{
    int count{ };
    check = ((EvDesc *)ptr)->getParameterDescriptionCount(&count);

    return static_cast<double>(count);
}


// Fills a gm buffer with information for a parameter description.
// Returns 0 on success and -1 on error.
gms_export void fmod_studio_evdesc_get_paramdesc_by_name(char *ptr, char *name, char *buf_address)
{
    if (((EvDesc *)ptr)->isValid())
    {
        FMOD_STUDIO_PARAMETER_DESCRIPTION param;
        check = ((EvDesc *)ptr)->getParameterDescriptionByName(name, &param);
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
        }
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }
}


// Fills a gm buffer with information for a parameter description.
// Returns 0 on success and -1 on error.
gms_export void fmod_studio_evdesc_get_paramdesc_by_index(char *ptr, double index, char *buf_address)
{
    if (((EvDesc *)ptr)->isValid())
    {
        FMOD_STUDIO_PARAMETER_DESCRIPTION param{ };
        check = ((EvDesc *)ptr)->getParameterDescriptionByIndex(static_cast<int>(index), &param);
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
        }
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }
}

// Fills a gm buffer with information for a parameter description.
// Returns 0 on success and -1 on error.
gms_export void fmod_studio_evdesc_get_paramdesc_by_id(char *ptr, char *buf_address)
{

    if (((EvDesc *)ptr)->isValid())
    {
        Buffer buf(buf_address);
        FMOD_STUDIO_PARAMETER_ID id;

        id.data1 = buf.read<uint32_t>();
        id.data2 = buf.read<uint32_t>();

        FMOD_STUDIO_PARAMETER_DESCRIPTION param{ };
        check = ((EvDesc *)ptr)->getParameterDescriptionByID(id, &param);

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
        }
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }
}

// ============================================================================
// User Properties
// ============================================================================

/*
 * Retrieves the data of the user property.
 * Returns 0 on success and -1 on error.
 */
gms_export void fmod_studio_evdesc_get_user_property(char *ptr, const char *name, char *gmbuf)
{   
    if (((EvDesc *)ptr)->isValid())
    {
        FMOD_STUDIO_USER_PROPERTY prop;
        check = ((EvDesc *)ptr)->getUserProperty(name, &prop);
        if (check == FMOD_OK)
        {
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
                std::cerr << "GMFMOD Internal Error! Tried to get the value of user property \"" 
                    << prop.name << ", but the type of property was not supported.\n";
                break;
            }
        }
    }
}

/*
 * Retrieves the data of the user property at the indicated index.
 * Returns 0 on success and -1 on error.
 */
gms_export void fmod_studio_evdesc_get_user_property_by_index(char *ptr, double index, char *gmbuf)
{
    if (((EvDesc *)ptr)->isValid())
    {
        FMOD_STUDIO_USER_PROPERTY prop{ };
        check = ((EvDesc *)ptr)->getUserPropertyByIndex(static_cast<int>(index), &prop);
        if (check == FMOD_OK)
        {
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
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }
}

/*
 * Retrieves the number of user properties attached to an event description.
 * Returns the number of properties or -1 on error.
 */
gms_export double fmod_studio_evdesc_get_user_property_count(char *ptr)
{
    int count{ };
    check = ((EvDesc *)ptr)->getUserPropertyCount(&count);

    return static_cast<double>(count);
}

// ============================================================================
// General
// ============================================================================

gms_export void fmod_studio_evdesc_get_id(char *ptr, char *gm_buf)
{
    if (((EvDesc *)ptr)->isValid())
    {
        FMOD_GUID id{ };
        check = ((EvDesc *)ptr)->getID(&id);
        if (check == FMOD_OK)
        {
            Buffer buffer(gm_buf);
            buffer.write<uint32_t>(id.Data1);
            buffer.write<uint16_t>(id.Data2);
            buffer.write<uint16_t>(id.Data3);

            for (int i = 0; i < 8; ++i)
            {
                buffer.write<uint8_t>(id.Data4[i]);
            }
        }
    }
}

/*
 * Gets the length of the EventDescription in milliseconds.
 * Returns length or -1 on error.
 */
gms_export double fmod_studio_evdesc_get_length(char *ptr)
{
    int length{ };
    check = ((EvDesc *)ptr)->getLength(&length);

    return static_cast<double>(length);
}

/*
 * Gets the path of the EventDescription.
 * Returns path or nullptr on error.
 */
gms_export const char *fmod_studio_evdesc_get_path(char *ptr)
{
    static std::string ret;

    if (((EvDesc *)ptr)->isValid())
    {
        char path[100];
        check = ((EvDesc *)ptr)->getPath(path, 100, nullptr);
        if (check == FMOD_OK)
        {
            ret.assign(path);
        }
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }

    return ret.c_str();
}

/*
 * Checks if the EventDescription reference is valid.
 * Returns true or false.
 */
gms_export double fmod_studio_evdesc_is_valid(char *ptr)
{
    return (((EvDesc *)ptr)->isValid());
}
