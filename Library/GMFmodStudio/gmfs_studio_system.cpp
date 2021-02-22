#include "gmfs_common.h"
#include <fmod_errors.h>
#include <iostream>
#include <vector>

std::vector<FMOD_STUDIO_PARAMETER_DESCRIPTION> fmod_studio_global_params;

gms_export int fmod_studio_get_error()
{
    return static_cast<int>(check);
}

gms_export const char *fmod_studio_get_error_string()
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
    FMOD::Studio::System *fmod_studio_system;
    check = FMOD::Studio::System::create(&fmod_studio_system);

    if (check == FMOD_OK)
        return (double)(uintptr_t)fmod_studio_system;
    else
        return 0;
}

gms_export void fmod_studio_system_initialize(char *raw_studio_ptr, double max_channels, double studio_flags, double lowlevel_flags)
{
    auto studio = (FMOD::Studio::System *)raw_studio_ptr;
    check = studio->initialize(static_cast<int>(max_channels),
        static_cast<FMOD_STUDIO_INITFLAGS>(studio_flags),
        static_cast<FMOD_INITFLAGS>(lowlevel_flags),
        nullptr);
}

// Releases studio system resources.
// Returns true on success, and false on error.
gms_export double fmod_studio_system_release(char *raw_studio_ptr)
{
    auto studio = (FMOD::Studio::System *)raw_studio_ptr;
    check = studio->release();

    return (check == FMOD_OK);
}


// ============================================================================
// Update
// ============================================================================

gms_export void fmod_studio_system_update(char *raw_studio_ptr)
{
    auto studio = (FMOD::Studio::System *)raw_studio_ptr;
    check = studio->update();
}

// Flushes commands from Studio System.
// Returns true on success, and false on error.
gms_export double fmod_studio_system_flush_commands(char *raw_studio_ptr)
{
    auto studio = (FMOD::Studio::System *)(raw_studio_ptr);
    check = studio->flushCommands();

    return (check == FMOD_OK);
}

// Flushes commands from Studio System.
// Returns true on success, and false on error.
gms_export double fmod_studio_system_flush_sample_loading(char *raw_studio_ptr)
{
    auto studio = (FMOD::Studio::System *)(raw_studio_ptr);
    check = studio->flushSampleLoading();

    return (check == FMOD_OK);
}

// ============================================================================
// Banks
// ============================================================================

// Returns loaded Studio Bank ptr or 0 if error
gms_export double fmod_studio_system_load_bank_file(char *raw_studio_ptr, const char *path)
{
    auto studio = (FMOD::Studio::System *)(raw_studio_ptr);
    double ret = 0;

    FMOD::Studio::Bank *bank;

    check = studio->loadBankFile(path, FMOD_STUDIO_LOAD_BANK_NORMAL, &bank);
    if (check == FMOD_OK)
        ret = (double)(uintptr_t)bank;

    return ret;
}
 
// loadBankCustom not applicable
// TODO: loadBankMemory

// Unloads all banks from Studio System.
// Returns true on success, and false on error.
gms_export double fmod_studio_system_unload_all(char *raw_studio_ptr)
{
    auto studio = (FMOD::Studio::System *)(raw_studio_ptr);
    check = studio->unloadAll();

    return (check == FMOD_OK);
}

gms_export double fmod_studio_system_get_bank(char *raw_studio_ptr, char *path)
{
    auto studio = (FMOD::Studio::System *)(raw_studio_ptr);
    FMOD::Studio::Bank *bank = nullptr;
    check = studio->getBank(path, &bank);

    return (double)(uintptr_t)bank;
}

gms_export double fmod_studio_system_get_bank_by_id(char *raw_studio_ptr, char *gmbuf)
{
    auto studio = (FMOD::Studio::System *)(raw_studio_ptr);
    FMOD::Studio::Bank *bank = nullptr;

    Buffer buffer(gmbuf);
    FMOD_GUID id;

    id.Data1 = buffer.read<uint32_t>();
    id.Data2 = buffer.read<uint16_t>();
    id.Data3 = buffer.read<uint16_t>();

    for (int i = 0; i < 8; ++i)
    {
        id.Data4[i] = buffer.read<uint8_t>();
    }
    
    check = studio->getBankByID(&id, &bank);

    return (double)(uintptr_t)bank;
}

gms_export double fmod_studio_system_get_bank_count(char *raw_studio_ptr)
{
    auto studio = (FMOD::Studio::System *)(raw_studio_ptr);
    int count = -1;
    check = studio->getBankCount(&count);

    return (double)count;
}

// Fills a buffer with an array of all the loaded banks as ptrs cast to uint64.
// Slow because of dynamic memory allocation.
// Returns count written on success and -1 on error.
gms_export double fmod_studio_system_get_bank_list(char *evt_ptr, double capacity, char *gmbuf)
{
    double ret = -1;
    auto studio = (FMOD::Studio::System *)evt_ptr;
    if (!studio || !studio->isValid()) return ret;

    int count;
    studio->getBankCount(&count);
    if (count > capacity)
        count = (int)capacity;

    FMOD::Studio::Bank **banks = new FMOD::Studio::Bank * [(int)count];
    check = studio->getBankList(banks, count, &count);

    if (check == FMOD_OK)
    {
        ret = (double)count;
        Buffer buf(gmbuf);
        for (int i = 0; i < count; ++i)
        {
            buf.write<uint64_t>((uint64_t)(uintptr_t)banks[i]);
        }
    }

    delete[] banks;
    return ret;
}

gms_export double fmod_studio_system_set_listener_attributes(char *ptr, double listener, char *gmbuf)
{
    auto studio = (FMOD::Studio::System *)ptr;

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

    check = studio->setListenerAttributes((int)listener, &attr, nullptr);
    
    return (check == FMOD_OK) ? 0 : -1;
}

gms_export double fmod_studio_system_get_listener_attributes(char *ptr, double listener, char *gmbuf)
{
    auto sys = (FMOD::Studio::System *)ptr;

    FMOD_3D_ATTRIBUTES attr;
    check = sys->getListenerAttributes((int)listener, &attr, nullptr);

    if (check != FMOD_OK) return -1;

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

    return 0;
}


gms_export double fmod_studio_system_set_listener_weight(char *ptr, double listener, double weight)
{
    auto studio = (FMOD::Studio::System *)(ptr);
    
    check = studio->setListenerWeight((int)listener, (float)weight);

    return (check == FMOD_OK) ? 0 : -1;
}

gms_export double fmod_studio_system_get_listener_weight(char *ptr, double listener)
{
    auto studio = (FMOD::Studio::System *)(ptr);
    
    float weight;
    check = studio->getListenerWeight((int)listener, &weight);

    return (check == FMOD_OK) ? (double)weight : -1;
}

gms_export double fmod_studio_system_set_num_listeners(char *ptr, double listeners)
{
    auto studio = (FMOD::Studio::System *)(ptr);
    
    check = studio->setNumListeners((int)listeners);

    return (check == FMOD_OK) ? 0 : -1;
}

gms_export double fmod_studio_system_get_num_listeners(char *ptr)
{
    auto studio = (FMOD::Studio::System *)(ptr);
    
    int listener_count;
    check = studio->getNumListeners(&listener_count);

    return (check == FMOD_OK) ? (double)listener_count : -1;
}

gms_export double fmod_studio_system_get_bus(char *ptr, char *path)
{
    auto studio = (FMOD::Studio::System *)(ptr);
    
    FMOD::Studio::Bus *bus;
    check = studio->getBus(path, &bus);

    return (check == FMOD_OK) ? (double)(uintptr_t)bus : 0;
}

gms_export double fmod_studio_system_get_bus_by_id(char *raw_studio_ptr, char *gmbuf)
{
    auto studio = (FMOD::Studio::System *)(raw_studio_ptr);
    FMOD::Studio::Bus *bus = nullptr;

    Buffer buffer(gmbuf);
    FMOD_GUID id;

    id.Data1 = buffer.read<uint32_t>();
    id.Data2 = buffer.read<uint16_t>();
    id.Data3 = buffer.read<uint16_t>();

    for (int i = 0; i < 8; ++i)
    {
        id.Data4[i] = buffer.read<uint8_t>();
    }

    check = studio->getBusByID(&id, &bus);

    return (double)(uintptr_t)bus;
}

gms_export double fmod_studio_system_get_event(char *raw_studio_ptr, const char *path)
{
    auto studio = (FMOD::Studio::System *)raw_studio_ptr;
    FMOD::Studio::EventDescription *desc;
    check = studio->getEvent(path, &desc);
    return (double)(uintptr_t)desc;
}

gms_export double fmod_studio_system_get_event_by_id(char *raw_studio_ptr, char *gm_buffer)
{
    auto studio = (FMOD::Studio::System *)(raw_studio_ptr);
    FMOD::Studio::EventDescription *desc;
    FMOD_GUID guid;

    Buffer buf(gm_buffer);
    guid.Data1 = buf.read<uint32_t>();
    guid.Data2 = buf.read<uint16_t>();
    guid.Data3 = buf.read<uint16_t>();

    for (int i = 0; i < 8; ++i)
    {
        guid.Data4[i] = buf.read<uint8_t>();
    }

    check = studio->getEventByID(&guid, &desc);

    return (double)(uintptr_t)desc;
}

// ============================================================================
// Parameters
// ============================================================================

gms_export double fmod_studio_system_set_parameter_by_name(char *ptr, char *name, double value, double ignoreseekspeed)
{
    auto studio = (FMOD::Studio::System *)ptr;
    double ret = -1;

    if (studio && studio->isValid())
    {
        check = studio->setParameterByName(name, (float)value, (bool)ignoreseekspeed);

        if (check == FMOD_OK)
            ret = 0;
    }

    return ret;
}

gms_export double fmod_studio_system_get_parameter_by_name(char *ptr, char *name)
{
    auto studio = (FMOD::Studio::System *)ptr;
    double ret = -1;

    if (studio && studio->isValid())
    {
        float value;
        check = studio->getParameterByName(name, &value, nullptr);

        if (check == FMOD_OK)
            ret = static_cast<double>(value);
    }

    return ret;
}

gms_export double fmod_studio_system_get_parameter_by_name_final(char *ptr, char *name)
{
    auto studio = (FMOD::Studio::System *)ptr;
    double ret = -1;

    if (studio && studio->isValid())
    {
        float value;
        check = studio->getParameterByName(name, nullptr, &value);

        if (check == FMOD_OK)
            ret = static_cast<double>(value);
    }

    return ret;
}

gms_export double fmod_studio_studio_set_parameter_by_id(char *ptr, char *gmbuf, double value, double ignoreseekspeed)
{
    auto studio = (FMOD::Studio::System *)ptr;
    double ret = -1;

    if (studio && studio->isValid())
    {
        Buffer buf(gmbuf);
        FMOD_STUDIO_PARAMETER_ID id;
        id.data1 = buf.read<uint32_t>();
        id.data2 = buf.read<uint32_t>();

        check = studio->setParameterByID(id, static_cast<float>(value), static_cast<bool>(ignoreseekspeed));

        if (check == FMOD_OK)
            ret = 0;
    }

    return ret;
}

// buffer must be uin32_t, uint32_t, float for each set of ParameterID + value.
gms_export double fmod_studio_studio_set_parameters_by_ids(char *ptr, char *gmbuf, double count, double ignoreseekspeed)
{
    auto studio = (FMOD::Studio::System *)ptr;
    double ret = -1;

    if (studio && studio->isValid())
    {
        Buffer buf(gmbuf);
        FMOD_STUDIO_PARAMETER_ID *ids = new FMOD_STUDIO_PARAMETER_ID[(int)count];
        float *values = new float[(int)count];

        for (int i = 0; i < (int)count; ++i)
        {
            ids[i] = { buf.read<uint32_t>(), buf.read<uint32_t>() };
            values[i] = buf.read<float>();
        }

        check = studio->setParametersByIDs(ids, values, (int)count, (bool)ignoreseekspeed);

        if (check == FMOD_OK)
            ret = 0;

        delete[] ids;
        delete[] values;
    }

    return ret;
}

gms_export double fmod_studio_studio_get_parameter_by_id(char *ptr, char *gmbuf)
{
    auto studio = (FMOD::Studio::System *)ptr;
    double ret = -1;

    if (studio && studio->isValid())
    {
        Buffer buf(gmbuf);
        FMOD_STUDIO_PARAMETER_ID id;
        id.data1 = buf.read<uint32_t>();
        id.data2 = buf.read<uint32_t>();

        float value;
        check = studio->getParameterByID(id, &value, nullptr);

        if (check == FMOD_OK)
            ret = static_cast<double>(value);
    }

    return ret;
}

gms_export double fmod_studio_studio_get_parameter_by_id_final(char *ptr, char *gmbuf)
{
    auto studio = (FMOD::Studio::System *)ptr;
    double ret = -1;

    if (studio && studio->isValid())
    {
        Buffer buf(gmbuf);
        FMOD_STUDIO_PARAMETER_ID id;
        id.data1 = buf.read<uint32_t>();
        id.data2 = buf.read<uint32_t>();

        float value;
        check = studio->getParameterByID(id, nullptr, &value);

        if (check == FMOD_OK)
            ret = static_cast<double>(value);
    }

    return ret;
}

gms_export double fmod_studio_system_get_paramdesc_count(char *ptr)
{
    auto studio = (FMOD::Studio::System *)ptr;
    double ret = -1;

    if (studio && studio->isValid())
    {
        int count;
        check = studio->getParameterDescriptionCount(&count);

        if (check == FMOD_OK)
        {
            ret = (double)count;
        }
    }

    return ret;
}

gms_export double fmod_studio_system_get_paramdesc_by_index(char *ptr, double index, char *gmbuf)
{
    auto studio = (FMOD::Studio::System *)ptr;
    double ret = -1;

    // flag that checks if the user has queried the parameter descriptions or not yet.
    static bool queried;

    if (studio && studio->isValid())
    {
        // Set the global var storage of paramdescs once
        if (!queried)
        {
            int count;
            studio->getParameterDescriptionCount(&count);

            FMOD_STUDIO_PARAMETER_DESCRIPTION *params = new FMOD_STUDIO_PARAMETER_DESCRIPTION[count];
            studio->getParameterDescriptionList(params, count, nullptr);

            for (int i = 0; i < count; ++i)
            {
                
                fmod_studio_global_params.emplace_back(params[i]);
            }

            queried = true;
            delete[] params;
        }

        if (index >= fmod_studio_global_params.size())
        {
            std::cerr << "GMFMS Error! Queried an index of an array of global parameter descriptions out of range!\n";
            return -1;
        }

        FMOD_STUDIO_PARAMETER_DESCRIPTION &param = fmod_studio_global_params[(int)index];
        if (check == FMOD_OK)
        {
            Buffer buf(gmbuf);
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




// TODO: Parameter functions

// ============================================================================
// VCA
// ============================================================================

gms_export double fmod_studio_system_get_vca(char *raw_studio_ptr, const char *path)
{
    auto studio = (FMOD::Studio::System *)raw_studio_ptr;
    FMOD::Studio::VCA *vca;
    check = studio->getVCA(path, &vca);
    return (double)(uintptr_t)vca;
}

gms_export double fmod_studio_system_get_vca_by_id(char *raw_studio_ptr, char *gm_buffer)
{
    auto studio = (FMOD::Studio::System *)(raw_studio_ptr);
    FMOD::Studio::VCA *vca;
    FMOD_GUID guid;

    Buffer buf(gm_buffer);
    guid.Data1 = buf.read<uint32_t>();
    guid.Data2 = buf.read<uint16_t>();
    guid.Data3 = buf.read<uint16_t>();

    for (int i = 0; i < 8; ++i)
    {
        guid.Data4[i] = buf.read<uint8_t>();
    }

    check = studio->getVCAByID(&guid, &vca);

    return (double)(uintptr_t)vca;
}

// ============================================================================
// Advanced Settings
// ============================================================================

gms_export double fmod_studio_system_set_advanced_settings(char *raw_studio_ptr, char *gm_buffer)
{
    auto studio = (FMOD::Studio::System *)(raw_studio_ptr);

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

    check = studio->setAdvancedSettings(&settings);

    return (check == FMOD_OK) ? 0 : -1;
}

gms_export double fmod_studio_system_get_advanced_settings(char *raw_studio_ptr, char *gm_buffer)
{
    auto studio = (FMOD::Studio::System *)(raw_studio_ptr);
    
    FMOD_STUDIO_ADVANCEDSETTINGS settings;

    check = studio->getAdvancedSettings(&settings);

    if (check == FMOD_OK)
    {
        Buffer buf(gm_buffer);
        buf.write<uint32_t>(settings.commandqueuesize);
        buf.write<uint32_t>(settings.handleinitialsize);
        buf.write<uint32_t>(settings.studioupdateperiod);
        buf.write<uint32_t>(settings.idlesampledatapoolsize);
        buf.write<uint32_t>(settings.streamingscheduledelay);
        buf.write_string(settings.encryptionkey);
        
    }

    return (check == FMOD_OK) ? 0 : -1;
}

// ============================================================================
// Command Capture and Replay
// ============================================================================

gms_export double fmod_studio_system_start_command_capture(char *raw_studio_ptr, char *filename, double flags)
{
    auto studio = (FMOD::Studio::System *)(raw_studio_ptr);
    check = studio->startCommandCapture(filename, (FMOD_STUDIO_COMMANDCAPTURE_FLAGS)flags);
;
    return (check == FMOD_OK) ? 0 : -1;
}

gms_export double fmod_studio_system_stop_command_capture(char *raw_studio_ptr)
{
    auto studio = (FMOD::Studio::System *)(raw_studio_ptr);
    check = studio->stopCommandCapture();

    return (check == FMOD_OK) ? 0 : -1;
}

gms_export double fmod_studio_system_load_command_replay(char *raw_studio_ptr, char *filename, double flags)
{
    auto studio = (FMOD::Studio::System *)(raw_studio_ptr);

    FMOD::Studio::CommandReplay *replay;
    check = studio->loadCommandReplay(
        filename, 
        (FMOD_STUDIO_COMMANDREPLAY_FLAGS)flags,
        &replay);

    return (check == FMOD_OK) ? (double)(uintptr_t)replay : 0;
}

// ============================================================================
// Profiling
// ============================================================================

gms_export double fmod_studio_system_get_buffer_usage(char *ptr, char *gmbuf)
{
    auto studio = (FMOD::Studio::System *)(ptr);

    FMOD_STUDIO_BUFFER_USAGE usage;
    check = studio->getBufferUsage(&usage);

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

    return 0;
}

gms_export double fmod_studio_system_reset_buffer_usage(char *ptr)
{
    auto studio = (FMOD::Studio::System *)(ptr);
    check = studio->resetBufferUsage();

    return (check == FMOD_OK) ? 0 : -1;
}

gms_export double fmod_studio_system_get_cpu_usage(char *ptr, char *gmbuf)
{
    auto studio = (FMOD::Studio::System *)(ptr);
    FMOD_STUDIO_CPU_USAGE usage;
    check = studio->getCPUUsage(&usage);

    if (check == FMOD_OK)
    {
        Buffer buf(gmbuf);
        buf.write(usage.dspusage);
        buf.write(usage.streamusage);
        buf.write(usage.geometryusage);
        buf.write(usage.updateusage);
        buf.write(usage.studiousage);
        return 0;
    }
    else
    {
        return -1;
    }
}

gms_export double fmod_studio_system_get_memory_usage(char *ptr, char *gmbuf)
{
    auto studio = (FMOD::Studio::System *)(ptr);
    FMOD_STUDIO_MEMORY_USAGE usage;
    check = studio->getMemoryUsage(&usage);

    if (check == FMOD_OK)
    {
        Buffer buf(gmbuf);
        buf.write<int32_t>(usage.exclusive);
        buf.write<int32_t>(usage.inclusive);
        buf.write<int32_t>(usage.sampledata);
        return 0;
    }
    else
    {
        return -1;
    }
}

// ============================================================================
// Custom DSP Plug-ins (not supported via GameMaker extension)
// ============================================================================


gms_export double fmod_studio_system_set_callback(char *ptr, double callbackmask)
{
    auto studio = (FMOD::Studio::System *)(ptr);
    check = studio->setCallback(fmod_studio_system_callback, (FMOD_STUDIO_SYSTEM_CALLBACK_TYPE)callbackmask);

    return (check == FMOD_OK) ? 0 : -1;
}


gms_export double fmod_studio_system_get_core_system(char *raw_studio_ptr)
{
    auto studio = (FMOD::Studio::System *)raw_studio_ptr;
    double ret = 0;
    FMOD::System *core;
    check = studio->getCoreSystem(&core);

    if (check == FMOD_OK)
        ret = (double)(uintptr_t)core;

    return ret;
}

// Lookup the GUID for a particular path and write it into the buffer.
// Returns 0 on success and -1 on error.
gms_export double fmod_studio_system_lookup_id(char *ptr, char *evpath, char *gmbuf)
{
    auto studio = (FMOD::Studio::System *)ptr;

    FMOD_GUID id;
    check = studio->lookupID(evpath, &id);
    double ret = -1;

    if (check == FMOD_OK)
    {
        Buffer buffer(gmbuf);
        ret = 0;

        buffer.write<uint32_t>(id.Data1);
        buffer.write<uint16_t>(id.Data2);
        buffer.write<uint16_t>(id.Data3);

        for (int i = 0; i < 8; ++i)
        {
            buffer.write<uint8_t>(id.Data4[i]);
        }
    }

    return ret;
}

// Lookup the path for a particular GUID and write it into the buffer.
// Returns path string or empty string if an error. Note: if a strings bank is not loaded, this will return empty as well.
gms_export const char *fmod_studio_system_lookup_path(char *ptr, char *evpath, char *gmbuf)
{
    auto studio = (FMOD::Studio::System *)ptr;
    static std::string str;

    FMOD_GUID id;
    Buffer buffer(gmbuf);

    id.Data1 = buffer.read<uint32_t>();
    id.Data2 = buffer.read<uint16_t>();
    id.Data3 = buffer.read<uint16_t>();

    for (int i = 0; i < 8; ++i)
    {
        id.Data4[i] = buffer.read<uint8_t>();
    }
    char pathbuf[PATH_MAX_LENGTH];
    check = studio->lookupPath(&id, pathbuf, PATH_MAX_LENGTH, nullptr);

    if (check == FMOD_OK)
    {
        str.assign(pathbuf);
        return str.c_str();
    }
    else
    {
        std::cerr << "FMOD Studio error, while looking up path: " << FMOD_ErrorString(check) << '\n';
        return "";
    }
}

gms_export double fmod_studio_system_is_valid(char *ptr)
{
    auto studio = (FMOD::Studio::System *)ptr;
    return studio->isValid();
}


