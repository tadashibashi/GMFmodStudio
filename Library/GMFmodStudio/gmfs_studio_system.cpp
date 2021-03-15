#include "gmfs_common.h"
#include <fmod_errors.h>
#include <iostream>
#include <vector>

std::vector<FMOD_STUDIO_PARAMETER_DESCRIPTION> fmod_studio_global_params;

typedef FMOD::Studio::System StudioSystem;

gms_export double gmfms_get_error()
{
    return static_cast<double>(check);
}

gms_export const char *gmfms_get_error_string()
{
    return FMOD_ErrorString(check);
}

gms_export const char *gmfms_interpret_string(double ptr)
{
    return (const char *)(uintptr_t)ptr;
}

FMOD_RESULT F_CALLBACK fmod_studio_system_callback(
    FMOD_STUDIO_SYSTEM *system,
    FMOD_STUDIO_SYSTEM_CALLBACK_TYPE type,
    void *commanddata,
    void *userdata)
{
    GM_DsMap map;
    map.AddString("fmodCallbackType", "StudioSystem");
    map.AddDouble("system", (double)(uintptr_t)system);
    map.AddDouble("type", (double)type);
    map.AddDouble("commanddata", (double)(uintptr_t)commanddata);
    map.AddDouble("userdata", (double)(uintptr_t)userdata);

    map.SendAsyncEvent();

    return FMOD_OK;
}

// ============================================================================
// Lifetime
// ============================================================================

// Creates a studio system object
gms_export double fmod_studio_system_create()
{
    FMOD::Studio::System *fmod_studio_system = nullptr;
    check = FMOD::Studio::System::create(&fmod_studio_system);
    return (double)(uintptr_t)fmod_studio_system;
}

gms_export void fmod_studio_system_initialize(char *ptr, double max_channels, double studio_flags, double lowlevel_flags)
{
    check = ((StudioSystem *)ptr)->initialize(static_cast<int>(max_channels),
        static_cast<FMOD_STUDIO_INITFLAGS>(studio_flags),
        static_cast<FMOD_INITFLAGS>(lowlevel_flags),
        nullptr);
}

// Releases studio system resources.
// Returns true on success, and false on error.
gms_export void fmod_studio_system_release(char *ptr)
{
    check = ((FMOD::Studio::System *)ptr)->release();
}

// ============================================================================
// Update
// ============================================================================

gms_export void fmod_studio_system_update(char *ptr)
{
    auto studio = (FMOD::Studio::System *)ptr;
    check = studio->update();
}

// Flushes commands from Studio System.
// Returns true on success, and false on error.
gms_export void fmod_studio_system_flush_commands(char *ptr)
{
    check = ((StudioSystem *)ptr)->flushCommands();
}

// Flushes commands from Studio System.
// Returns true on success, and false on error.
gms_export void fmod_studio_system_flush_sample_loading(char *ptr)
{
    check = ((StudioSystem *)ptr)->flushSampleLoading();
}

// ============================================================================
// Banks
// ============================================================================

// Returns loaded Studio Bank ptr or 0 if error
gms_export double fmod_studio_system_load_bank_file(char *ptr, const char *path, double flags)
{
    auto studio = (FMOD::Studio::System *)(ptr);
    double ret = 0;

    FMOD::Studio::Bank *bank;

    check = studio->loadBankFile(path, (FMOD_STUDIO_LOAD_BANK_FLAGS)flags, &bank);
    if (check == FMOD_OK)
        ret = (double)(uintptr_t)bank;

    return ret;
}
 
// loadBankCustom not applicable
// TODO: loadBankMemory

// Unloads all banks from Studio System.
gms_export void fmod_studio_system_unload_all(char *ptr)
{
    check = ((StudioSystem *)ptr)->unloadAll();
}

gms_export double fmod_studio_system_get_bank(char *ptr, char *path)
{
    FMOD::Studio::Bank *bank = nullptr;
    check = ((StudioSystem *)ptr)->getBank(path, &bank);

    return (double)(uintptr_t)bank;
}

gms_export double fmod_studio_system_get_bank_by_id(char *ptr, char *gmbuf)
{

    FMOD::Studio::Bank *bank = nullptr;

    if (((StudioSystem *)ptr)->isValid())
    {
        Buffer buffer(gmbuf);
        FMOD_GUID id;

        id.Data1 = buffer.read<uint32_t>();
        id.Data2 = buffer.read<uint16_t>();
        id.Data3 = buffer.read<uint16_t>();

        for (int i = 0; i < 8; ++i)
        {
            id.Data4[i] = buffer.read<uint8_t>();
        }

        check = ((StudioSystem *)ptr)->getBankByID(&id, &bank);
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }

    return (double)(uintptr_t)bank;
}

gms_export double fmod_studio_system_get_bank_count(char *ptr)
{
    int count = -1;
    check = ((StudioSystem *)ptr)->getBankCount(&count);

    return (double)count;
}

// Fills a buffer with an array of all the loaded banks as ptrs cast to uint64.
// Slow because of dynamic memory allocation.
// Returns the count of written banks.
gms_export double fmod_studio_system_get_bank_list(char *ptr, double capacity, char *gmbuf)
{
    int count = 0;
    if (((StudioSystem *)ptr)->isValid())
    {
        check = ((StudioSystem *)ptr)->getBankCount(&count);
        if (check != FMOD_OK) return count;

        if (count > capacity)
            count = (int)capacity;

        FMOD::Studio::Bank **banks = new FMOD::Studio::Bank * [(int)count];
        check = ((StudioSystem *)ptr)->getBankList(banks, count, &count);

        if (check == FMOD_OK)
        {
            Buffer buf(gmbuf);
            for (int i = 0; i < count; ++i)
            {
                buf.write<uint64_t>((uint64_t)(uintptr_t)banks[i]);
            }
        }
        
        delete[] banks;
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }

    return static_cast<double>(count);
}

// ============================================================================
// Listeners
// ============================================================================

gms_export void fmod_studio_system_set_listener_attributes(char *ptr, double listener, char *gmbuf)
{
    if (((StudioSystem *)ptr)->isValid())
    {
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

        check = ((StudioSystem *)ptr)->setListenerAttributes((int)listener, &attr, nullptr);
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }
}

gms_export void fmod_studio_system_get_listener_attributes(char *ptr, double listener, char *gmbuf)
{
    FMOD_3D_ATTRIBUTES attr;
    check = ((StudioSystem *)ptr)->getListenerAttributes((int)listener, &attr, nullptr);

    if (check != FMOD_OK) return;

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


gms_export void fmod_studio_system_set_listener_weight(char *ptr, double listener, double weight)
{
    check = ((StudioSystem *)ptr)->setListenerWeight((int)listener, (float)weight);
}

gms_export double fmod_studio_system_get_listener_weight(char *ptr, double listener)
{   
    float weight{ };
    check = ((StudioSystem *)ptr)->getListenerWeight((int)listener, &weight);

    return static_cast<double>(weight);
}

gms_export void fmod_studio_system_set_num_listeners(char *ptr, double listeners)
{
    check = ((StudioSystem *)ptr)->setNumListeners((int)listeners);
}

gms_export double fmod_studio_system_get_num_listeners(char *ptr)
{
    int listener_count{ };
    check = ((StudioSystem *)ptr)->getNumListeners(&listener_count);

    return static_cast<double>(listener_count);
}


// ============================================================================
// Busses
// ============================================================================

gms_export double fmod_studio_system_get_bus(char *ptr, char *path)
{   
    FMOD::Studio::Bus *bus{ };
    check = ((StudioSystem *)ptr)->getBus(path, &bus);

    return (double)(uintptr_t)bus;
}

gms_export double fmod_studio_system_get_bus_by_id(char *ptr, char *gmbuf)
{
    FMOD::Studio::Bus *bus{ };
    if (((StudioSystem *)ptr)->isValid())
    {
        Buffer buffer(gmbuf);
        FMOD_GUID id;

        id.Data1 = buffer.read<uint32_t>();
        id.Data2 = buffer.read<uint16_t>();
        id.Data3 = buffer.read<uint16_t>();

        for (int i = 0; i < 8; ++i)
        {
            id.Data4[i] = buffer.read<uint8_t>();
        }

        check = ((StudioSystem *)ptr)->getBusByID(&id, &bus);
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }
    
    return (double)(uintptr_t)bus;
}

// ============================================================================
// Events
// ============================================================================

gms_export double fmod_studio_system_get_event(char *ptr, const char *path)
{
    FMOD::Studio::EventDescription *desc{ };
    check = ((StudioSystem *)ptr)->getEvent(path, &desc);

    return (double)(uintptr_t)desc;
}

gms_export double fmod_studio_system_get_event_by_id(char *ptr, char *gm_buffer)
{
    FMOD::Studio::EventDescription *desc{ };

    if (((StudioSystem *)ptr)->isValid())
    {
        Buffer buf(gm_buffer);
        FMOD_GUID guid{
            buf.read<uint32_t>(),
            buf.read<uint16_t>(),
            buf.read<uint16_t>(),
            buf.read<uint8_t>(),
            buf.read<uint8_t>(),
            buf.read<uint8_t>(),
            buf.read<uint8_t>(),
            buf.read<uint8_t>(),
            buf.read<uint8_t>(),
            buf.read<uint8_t>(),
            buf.read<uint8_t>(),
        };

        check = ((StudioSystem *)ptr)->getEventByID(&guid, &desc);
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }

    return (double)(uintptr_t)desc;
}

// ============================================================================
// Parameters
// ============================================================================

gms_export void fmod_studio_system_set_parameter_by_name(char *ptr, char *name, double value, double ignoreseekspeed)
{
    check = ((StudioSystem *)ptr)->setParameterByName(name, (float)value, (bool)ignoreseekspeed);
}

gms_export double fmod_studio_system_get_parameter_by_name(char *ptr, char *name)
{
    float value{ };
    check = ((StudioSystem *)ptr)->getParameterByName(name, &value, nullptr);
    return static_cast<double>(value);
}

gms_export double fmod_studio_system_get_parameter_by_name_final(char *ptr, char *name)
{
    float value{ };
    check = ((StudioSystem *)ptr)->getParameterByName(name, nullptr, &value);
    return static_cast<double>(value);
}

// Note: Buffer must contain a series of values: uint32_t, uint32_t, float for each param id + value
gms_export void fmod_studio_system_set_parameter_by_id(char *ptr, char *gmbuf, double value, double ignoreseekspeed)
{
    if (((StudioSystem *)ptr)->isValid())
    {
        Buffer buf(gmbuf);
        FMOD_STUDIO_PARAMETER_ID id;
        id.data1 = buf.read<uint32_t>();
        id.data2 = buf.read<uint32_t>();

        check = ((StudioSystem *)ptr)->setParameterByID(id, static_cast<float>(value), static_cast<bool>(ignoreseekspeed));
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }
}

// buffer must be uin32_t, uint32_t, float for each set of ParameterID + value.
gms_export void fmod_studio_system_set_parameters_by_ids(char *ptr, char *gmbuf, double count, double ignoreseekspeed)
{
    if (((StudioSystem *)ptr)->isValid())
    {
        Buffer buf(gmbuf);
        FMOD_STUDIO_PARAMETER_ID *ids = new FMOD_STUDIO_PARAMETER_ID[(int)count];
        float *values = new float[(int)count];

        for (int i = 0; i < (int)count; ++i)
        {
            ids[i] = { buf.read<uint32_t>(), buf.read<uint32_t>() };
            values[i] = buf.read<float>();
        }

        check = ((StudioSystem *)ptr)->setParametersByIDs(ids, values, (int)count, (bool)ignoreseekspeed);

        delete[] ids;
        delete[] values;
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }
}

gms_export double fmod_studio_system_get_parameter_by_id(char *ptr, char *gmbuf)
{
    float value{ };

    Buffer buf(gmbuf);
    FMOD_STUDIO_PARAMETER_ID id {
        buf.read<uint32_t>(),
        buf.read<uint32_t>(),
    };
  
    check = ((StudioSystem *)ptr)->getParameterByID(id, &value, nullptr);
   
    return static_cast<double>(value);
}

gms_export double fmod_studio_system_get_parameter_by_id_final(char *ptr, char *gmbuf)
{
    float value{ };

    Buffer buf(gmbuf);
    FMOD_STUDIO_PARAMETER_ID id{
        buf.read<uint32_t>(),
        buf.read<uint32_t>(),
    };

    check = ((StudioSystem *)ptr)->getParameterByID(id, nullptr, &value);

    return static_cast<double>(value);
}

gms_export double fmod_studio_system_get_paramdesc_count(char *ptr)
{
    int count{ };
    check = ((StudioSystem *)ptr)->getParameterDescriptionCount(&count);

    return static_cast<double>(count);
}

gms_export void fmod_studio_system_get_paramdesc_by_index(char *ptr, double index, char *gmbuf)
{
    auto studio = (FMOD::Studio::System *)ptr;

    // Flag that checks the last queried system. Prevents needing to query every time a studio
    // system makes sequential calls.
    static uintptr_t queried;

    if (studio->isValid())
    {
        // Set the global var storage of paramdescs once
        if (queried != (uintptr_t)ptr)
        {
            fmod_studio_global_params.clear();
            int count{ };
            check = studio->getParameterDescriptionCount(&count);
            if (check != FMOD_OK) return;

            if (count > 0)
            {
                FMOD_STUDIO_PARAMETER_DESCRIPTION *params = new FMOD_STUDIO_PARAMETER_DESCRIPTION[count];
                check = studio->getParameterDescriptionList(params, count, &count);
                if (check != FMOD_OK)
                {
                    delete[] params;
                    return;
                }

                for (int i = 0; i < count; ++i)
                {
                    fmod_studio_global_params.push_back(params[i]);
                }

                
                delete[] params;
            }

            queried = (uintptr_t)ptr;
        }

        // Ensure index is in range.
        if (index >= fmod_studio_global_params.size())
        {
            std::cerr << "GMFMOD Fatal Error! Queried an index of an array of global parameter descriptions out of range!\n";
            return;
        }

        FMOD_STUDIO_PARAMETER_DESCRIPTION &param = fmod_studio_global_params[(int)index];

        Buffer buf(gmbuf);
        buf.write_char_star(param.name);
        buf.write<uint32_t>(param.id.data1);
        buf.write<uint32_t>(param.id.data2);
        buf.write(param.minimum);
        buf.write(param.maximum);
        buf.write(param.defaultvalue);
        buf.write<uint32_t>(param.type);
        buf.write<uint32_t>(param.flags);
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }
}


// ============================================================================
// VCA
// ============================================================================

gms_export double fmod_studio_system_get_vca(char *ptr, const char *path)
{
    FMOD::Studio::VCA *vca{ };
    check = ((StudioSystem *)ptr)->getVCA(path, &vca);
    return (double)(uintptr_t)vca;
}

gms_export double fmod_studio_system_get_vca_by_id(char *ptr, char *gm_buffer)
{
    FMOD::Studio::VCA *vca{ };
    
    if (((StudioSystem *)ptr)->isValid())
    {
        Buffer buf(gm_buffer);
        FMOD_GUID guid {
            buf.read<uint32_t>(),
            buf.read<uint16_t>(),
            buf.read<uint16_t>(),
        };

        for (int i = 0; i < 8; ++i)
        {
            guid.Data4[i] = buf.read<uint8_t>();
        }

        check = ((StudioSystem *)ptr)->getVCAByID(&guid, &vca);
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }

    return (double)(uintptr_t)vca;
}

// ============================================================================
// Advanced Settings
// ============================================================================

gms_export void fmod_studio_system_set_advanced_settings(char *ptr, char *gm_buffer)
{
    if (((StudioSystem *)ptr)->isValid())
    {
        Buffer buf(gm_buffer);

        FMOD_STUDIO_ADVANCEDSETTINGS settings {
            sizeof(FMOD_STUDIO_ADVANCEDSETTINGS),
            buf.read<uint32_t>(),
            buf.read<uint32_t>(),
            buf.read<int32_t>(),
            buf.read<int32_t>(),
            buf.read<uint32_t>(),
            buf.read_string(),
        };

        check = ((StudioSystem *)ptr)->setAdvancedSettings(&settings);
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }
}

gms_export void fmod_studio_system_get_advanced_settings(char *ptr, char *gm_buffer)
{   
    FMOD_STUDIO_ADVANCEDSETTINGS settings;
    settings.cbsize = sizeof(FMOD_STUDIO_ADVANCEDSETTINGS);
    check = ((StudioSystem *)ptr)->getAdvancedSettings(&settings);
   
    if (check == FMOD_OK)
    {
        Buffer buf(gm_buffer);
        buf.write<uint32_t>(settings.commandqueuesize);
        buf.write<uint32_t>(settings.handleinitialsize);
        buf.write<int32_t>(settings.studioupdateperiod);
        buf.write<int32_t>(settings.idlesampledatapoolsize);
        buf.write<uint32_t>(settings.streamingscheduledelay);
        if (settings.encryptionkey)
            buf.write_string(settings.encryptionkey);
        else
            buf.write_string("");
    }
}

// ============================================================================
// Command Capture and Replay
// ============================================================================

gms_export void fmod_studio_system_start_command_capture(char *ptr, char *filename, double flags)
{
    check = ((StudioSystem *)ptr)->startCommandCapture(filename, (FMOD_STUDIO_COMMANDCAPTURE_FLAGS)flags);
}

gms_export void fmod_studio_system_stop_command_capture(char *ptr)
{
    check = ((StudioSystem *)ptr)->stopCommandCapture();
}

gms_export double fmod_studio_system_load_command_replay(char *ptr, char *filename, double flags)
{
    FMOD::Studio::CommandReplay *replay{ };
    check = ((StudioSystem *)ptr)->loadCommandReplay(
        filename, 
        (FMOD_STUDIO_COMMANDREPLAY_FLAGS)flags,
        &replay);
    return (double)(uintptr_t)replay;
}

// ============================================================================
// Profiling
// ============================================================================

gms_export void fmod_studio_system_get_buffer_usage(char *ptr, char *gmbuf)
{
    FMOD_STUDIO_BUFFER_USAGE usage;
    check = ((StudioSystem *)ptr)->getBufferUsage(&usage);

    if (check == FMOD_OK)
    {
        Buffer buf(gmbuf);
        buf.write<int32_t>(usage.studiocommandqueue.currentusage);
        buf.write<int32_t>(usage.studiocommandqueue.peakusage);
        buf.write<int32_t>(usage.studiocommandqueue.capacity);
        buf.write<int32_t>(usage.studiocommandqueue.stallcount);
        buf.write<float>(usage.studiocommandqueue.stalltime);
        buf.write<int32_t>(usage.studiohandle.currentusage);
        buf.write<int32_t>(usage.studiohandle.peakusage);
        buf.write<int32_t>(usage.studiohandle.capacity);
        buf.write<int32_t>(usage.studiohandle.stallcount);
        buf.write<float>(usage.studiohandle.stalltime);
    }
}

gms_export void fmod_studio_system_reset_buffer_usage(char *ptr)
{
    check = ((StudioSystem *)ptr)->resetBufferUsage();
}

gms_export void fmod_studio_system_get_cpu_usage(char *ptr, char *gmbuf)
{
    FMOD_STUDIO_CPU_USAGE usage{ };
    check = ((StudioSystem *)ptr)->getCPUUsage(&usage);

    if (check == FMOD_OK)
    {
        Buffer buf(gmbuf);
        buf.write(usage.dspusage);
        buf.write(usage.streamusage);
        buf.write(usage.geometryusage);
        buf.write(usage.updateusage);
        buf.write(usage.studiousage);
    }
}

gms_export void fmod_studio_system_get_memory_usage(char *ptr, char *gmbuf)
{
    FMOD_STUDIO_MEMORY_USAGE usage;
    check = ((StudioSystem *)ptr)->getMemoryUsage(&usage);

    if (check == FMOD_OK)
    {
        Buffer buf(gmbuf);
        buf.write<int32_t>(usage.exclusive);
        buf.write<int32_t>(usage.inclusive);
        buf.write<int32_t>(usage.sampledata);
    }
}

// ============================================================================
// Custom DSP Plug-ins (not supported via GameMaker extension)
// ============================================================================

// ============================================================================
// General
// ============================================================================

gms_export void fmod_studio_system_set_callback(char *ptr, double callbackmask)
{
    check = ((StudioSystem *)ptr)->setCallback(
        fmod_studio_system_callback, 
        (FMOD_STUDIO_SYSTEM_CALLBACK_TYPE)callbackmask);
}

gms_export double fmod_studio_system_get_core_system(char *ptr)
{
    FMOD::System *core{ };
    check = ((StudioSystem *)ptr)->getCoreSystem(&core);

    return (double)(uintptr_t)core;;
}

// Lookup the GUID for a particular path and write it into the buffer.
// Returns 0 on success and -1 on error.
gms_export void fmod_studio_system_lookup_id(char *ptr, char *evpath, char *gmbuf)
{
    FMOD_GUID id{ };
    check = ((StudioSystem *)ptr)->lookupID(evpath, &id);

    if (check == FMOD_OK)
    {
        Buffer buffer(gmbuf);

        buffer.write<uint32_t>(id.Data1);
        buffer.write<uint16_t>(id.Data2);
        buffer.write<uint16_t>(id.Data3);

        for (int i = 0; i < 8; ++i)
        {
            buffer.write<uint8_t>(id.Data4[i]);
        }
    }
}

// Lookup the path for a particular GUID and write it into the buffer.
// Returns path string or empty string if an error. Note: if a strings bank is not loaded, this will return empty as well.
gms_export const char *fmod_studio_system_lookup_path(char *ptr, char *gmbuf)
{
    static std::string str;
    
    if (((StudioSystem *)ptr)->isValid())
    {
        Buffer buffer(gmbuf);

        FMOD_GUID id {
            buffer.read<uint32_t>(),
            buffer.read<uint16_t>(),
            buffer.read<uint16_t>(),
        };

        for (int i = 0; i < 8; ++i)
        {
            id.Data4[i] = buffer.read<uint8_t>();
        }

        char pathbuf[PATH_MAX_LENGTH];
        check = ((StudioSystem *)ptr)->lookupPath(&id, pathbuf, PATH_MAX_LENGTH, nullptr);

        if (check == FMOD_OK)
        {
            str.assign(pathbuf);
            return str.c_str();
        }
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }

    return "";
}

gms_export double fmod_studio_system_is_valid(char *ptr)
{
    return ((StudioSystem *)ptr)->isValid();
}


