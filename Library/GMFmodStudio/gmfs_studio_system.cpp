#include "gmfs_common.h"
#include "gmfs_buffer.h"
#include <fmod_errors.h>
#include <iostream>

gms_export int fmod_studio_get_error()
{
    return static_cast<int>(check);
}

gms_export const char *fmod_studio_get_error_string()
{
    return FMOD_ErrorString(check);
}

gms_export const char *__gmfmod_interpret_string(double ptr)
{
    return (const char *)(uintptr_t)ptr;
}

// ============================================================================
// Lifetime
// ============================================================================

// Creates a studio system object
gms_export double fmod_studio_system_create()
{
    FMOD::Studio::System *fmod_studio_system;
    check = FMOD::Studio::System::create(&fmod_studio_system);

    // Testing async event functionality.
    auto map = GM_DsMap();
    map.AddString("testVal", "Hello World!");
    map.SendAsyncEvent(GM_EVENT_OTHER_SOCIAL);

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

gms_export double fmod_studio_system_get_parameter_by_name(char *raw_studio_ptr, const char *param_name)
{
    auto studio = (FMOD::Studio::System *)(raw_studio_ptr);
    double ret = 0;
    float val;
    check = studio->getParameterByName(param_name, &val, nullptr);

    if (check == FMOD_OK)
        ret = static_cast<double>(val);

    return ret;
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

// Helper, send to GMS integration scripts instead
gms_export double fmod_studio_system_play_oneshot(char *raw_studio_ptr, const char *path)
{
    auto studio = (FMOD::Studio::System *)(raw_studio_ptr);
    FMOD::Studio::EventDescription *desc;
    check = studio->getEvent(path, &desc);
    if (check == FMOD_OK)
    {
        // Determine if this event is a oneshot.
        bool isOneshot;
        desc->isOneshot(&isOneshot);
        if (isOneshot) // it is, play event
        {
            FMOD::Studio::EventInstance *inst;
            check = desc->createInstance(&inst);
            inst->start();
            inst->release();

            return (double)(uintptr_t)inst;
        }
        else           // it is not, log error
        {
            std::cerr << "FMOD GMS2: Attempted to play a oneshot with event \"" << path <<
                "\", but it is not a oneshot.\n";
            return 0;
        }
    }
    else
    {
        return 0;
    }
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
