#include "gmfs_common.h"
#include <iostream>

typedef FMOD::Studio::Bank StudioBank;

// Gets the current loading state of a studio bank.
// Returns the loading state enum value or -1 on error.
gms_export double fmod_studio_bank_get_loading_state(char *ptr)
{
    FMOD_STUDIO_LOADING_STATE state{ };
    check = ((StudioBank *)ptr)->getLoadingState(&state);
    
    return static_cast<double>(state);
}

// Loads non-streaming sample data for all events in the bank.
// Returns 0 on success and -1 on error.
gms_export double fmod_studio_bank_load_sample_data(char *ptr)
{
    auto bank = (FMOD::Studio::Bank *)ptr;
    double ret = -1;

    if (bank && bank->isValid())
    {
        check = bank->loadSampleData();
    }

    return ret;
}

// Loads non-streaming sample data for all events in the bank.
// Returns 0 on success and -1 on error.
gms_export double fmod_studio_bank_unload_sample_data(char *ptr)
{
    auto bank = (FMOD::Studio::Bank *)ptr;
    double ret = -1;

    if (bank && bank->isValid())
    {
        check = bank->unloadSampleData();
    }

    return ret;
}

// Gets the current loading state of a studio bank.
// Returns the loading state enum value or -1 on error.
gms_export double fmod_studio_bank_get_sample_loading_state(char *ptr)
{
    FMOD_STUDIO_LOADING_STATE state{ };
    check = ((StudioBank *)ptr)->getSampleLoadingState(&state);

    return static_cast<double>(state);
}

// Unloads the bank.
// This will destroy all objects created from the bank, unload all sample
// data inside the bank, and invalidate all API handles referring to the bank.
// Returns 0 on success and -1 on error.
gms_export void fmod_studio_bank_unload(char *ptr)
{
    check = ((StudioBank *)ptr)->unload();
}

// Retrieves the number of busses in the bank.
// Returns the number of busses or -1 on error.
gms_export double fmod_studio_bank_get_bus_count(char *ptr)
{
    int count{ };
    check = ((StudioBank *)ptr)->getBusCount(&count);

    return static_cast<double>(count);
}

// Fills a buffer with an array of all the busses as ptrs cast to uint64.
// Slow because of dynamic memory allocation.
// Returns count of busses written to the buffer.
gms_export double fmod_studio_bank_get_bus_list(char *ptr, double capacity, char *gmbuf)
{   
    int count{ };
    if (((StudioBank *)ptr)->isValid())
    {
        
        check = ((StudioBank *)ptr)->getBusCount(&count);
        if (check != FMOD_OK) return count;

        if (count > capacity)
            count = (int)capacity;

        FMOD::Studio::Bus **busses = new FMOD::Studio::Bus * [(int)count];
        check = ((StudioBank *)ptr)->getBusList(busses, count, &count);

        if (check == FMOD_OK)
        {
            Buffer buf(gmbuf);
            for (int i = 0; i < count; ++i)
            {
                buf.write<uint64_t>((uint64_t)(uintptr_t)busses[i]);
            }
        }

        delete[] busses;
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }

    return static_cast<double>(count);
}

// Returns the number of busses or -1 on error.
gms_export double fmod_studio_bank_get_event_count(char *ptr)
{
    int count{ };
    check = ((StudioBank *)ptr)->getEventCount(&count);

    return static_cast<double>(count);
}

// Fills a buffer with an array of all the event descriptions as ptrs cast to uint64.
// Slow because of dynamic memory allocation.
// Returns count written on success and -1 on error.
gms_export double fmod_studio_bank_get_event_list(char *ptr, double capacity, char *gmbuf)
{
    int count{ };
    if (((StudioBank *)ptr)->isValid())
    {
        ((StudioBank *)ptr)->getEventCount(&count);
        if (count > capacity)
            count = (int)capacity;

        FMOD::Studio::EventDescription **events = new FMOD::Studio::EventDescription * [(int)count];
        check = ((StudioBank *)ptr)->getEventList(events, count, &count);

        if (check == FMOD_OK)
        {
            Buffer buf(gmbuf);
            for (int i = 0; i < count; ++i)
            {
                buf.write<uint64_t>((uint64_t)(uintptr_t)events[i]);
            }
        }

        delete[] events;
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }

    return static_cast<double>(count);
}

gms_export double fmod_studio_bank_get_string_count(char *ptr)
{
    int count{ };
    check = ((StudioBank *)ptr)->getStringCount(&count);
    
    return static_cast<double>(count);
}

// Gets guid from string info. Returns 0 on success and -1 on error.
gms_export void fmod_studio_bank_get_string_info_id(char *ptr, char *gmbuf, double index)
{

    if (((StudioBank *)ptr)->isValid())
    {
        FMOD_GUID id{ };
        check = ((StudioBank *)ptr)->getStringInfo((int)index, &id, nullptr, 0, nullptr);

        Buffer buffer(gmbuf);
        if (check == FMOD_OK)
        {
            buffer.write<uint32_t>(id.Data1);
            buffer.write<uint16_t>(id.Data2);
            buffer.write<uint16_t>(id.Data3);

            for (int i = 0; i < 8; ++i)
            {
                buffer.write<uint8_t>(id.Data4[i]);
            }
        }
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }
}

// Gets path from string info index
gms_export const char *fmod_studio_bank_get_string_info_path(char *ptr, double index)
{
    static std::string str;

    char buffer[PATH_MAX_LENGTH];
    check = ((StudioBank *)ptr)->getStringInfo(
        (int)index, nullptr, buffer, PATH_MAX_LENGTH, nullptr);

    return str.c_str();
}

// Returns the number of busses or -1 on error.
gms_export double fmod_studio_bank_get_vca_count(char *ptr)
{
    int count{ };
    check = ((StudioBank *)ptr)->getVCACount(&count);

    return static_cast<double>(count);
}

// Fills a buffer with an array of all the vcas as ptrs cast to uint64.
// Slow because of dynamic memory allocation.
// Returns count written on success and -1 on error.
gms_export double fmod_studio_bank_get_vca_list(char *ptr, double capacity, char *gmbuf)
{
    int count{ };
    if (((StudioBank *)ptr)->isValid())
    {
        ((StudioBank *)ptr)->getVCACount(&count);
        if (count > capacity)
            count = (int)capacity;

        FMOD::Studio::VCA **vcas = new FMOD::Studio::VCA * [(int)count];
        check = ((StudioBank *)ptr)->getVCAList(vcas, count, &count);

        if (check == FMOD_OK)
        {
            Buffer buf(gmbuf);
            for (int i = 0; i < count; ++i)
            {
                buf.write<uint64_t>((uint64_t)(uintptr_t)vcas[i]);
            }
        }

        delete[] vcas;
    }
    else
    {
        check = FMOD_ERR_INVALID_HANDLE;
    }

    return static_cast<double>(count);
}

gms_export double fmod_studio_bank_get_id(char *ptr, char *gmbuf)
{
    return fmod_studio_obj_get_id<FMOD::Studio::Bank>(ptr, gmbuf);
}

gms_export char *fmod_studio_bank_get_path(char *ptr)
{
    return fmod_studio_obj_get_path<FMOD::Studio::Bank>(ptr);
}

// Not implemented:
// setUserData (support strings and doubles)
// getUserData

gms_export double fmod_studio_bank_is_valid(char *ptr)
{
    return ((StudioBank *)ptr)->isValid();
}
