#include "gmfs_common.h"
#include <iostream>

// Gets the current loading state of a studio bank.
// Returns the loading state enum value or -1 on error.
gms_export double fmod_studio_bank_get_loading_state(char *ptr)
{
    auto bank = (FMOD::Studio::Bank *)ptr;
    double ret = -1;

    FMOD_STUDIO_LOADING_STATE state;
    check = bank->getLoadingState(&state);

    if (check == FMOD_OK)
        ret = static_cast<double>(state);

    return ret;
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
    auto bank = (FMOD::Studio::Bank *)ptr;
    double ret = -1;

    if (bank && bank->isValid())
    {
        FMOD_STUDIO_LOADING_STATE state;
        check = bank->getSampleLoadingState(&state);

        if (check == FMOD_OK)
            ret = static_cast<double>(state);
    }

    return ret;
}

// Unloads the bank.
// This will destroy all objects created from the bank, unload all sample
// data inside the bank, and invalidate all API handles referring to the bank.
// Returns 0 on success and -1 on error.
gms_export double fmod_studio_bank_unload(char *ptr)
{
    auto bank = (FMOD::Studio::Bank *)ptr;
    double ret = -1;

    if (bank && bank->isValid())
    {
        check = bank->unload();
    }

    return ret;
}

// Retrieves the number of busses in the bank.
// Returns the number of busses or -1 on error.
gms_export double fmod_studio_bank_get_bus_count(char *ptr)
{
    auto bank = (FMOD::Studio::Bank *)ptr;
    double ret = -1;

    if (bank && bank->isValid())
    {
        int count;
        check = bank->getBusCount(&count);
        if (check == FMOD_OK)
        {
            ret = static_cast<double>(count);
        }
    }

    return ret;
}

// Fills a buffer with an array of all the busses as ptrs cast to uint64.
// Slow because of dynamic memory allocation.
// Returns count written on success and -1 on error.
gms_export double fmod_studio_bank_get_bus_list(char *evt_ptr, double capacity, char *gmbuf)
{
    double ret = -1;
    auto bank = (FMOD::Studio::Bank *)evt_ptr;
    if (!bank || !bank->isValid()) return ret;

    int count;
    bank->getBusCount(&count);
    if (count > capacity)
        count = (int)capacity;

    FMOD::Studio::Bus **busses = new FMOD::Studio::Bus * [(int)count];
    check = bank->getBusList(busses, count, &count);

    if (check == FMOD_OK)
    {
        ret = (double)count;
        Buffer buf(gmbuf);
        for (int i = 0; i < count; ++i)
        {
            buf.write<uint64_t>((uint64_t)(uintptr_t)busses[i]);
        }
    }

    delete[] busses;
    return ret;
}

// Returns the number of busses or -1 on error.
gms_export double fmod_studio_bank_get_event_count(char *ptr)
{
    auto bank = (FMOD::Studio::Bank *)ptr;
    double ret = -1;

    if (bank && bank->isValid())
    {
        int count;
        check = bank->getBusCount(&count);
        if (check == FMOD_OK)
        {
            ret = static_cast<double>(count);
        }
    }

    return ret;
}

// Fills a buffer with an array of all the event descriptions as ptrs cast to uint64.
// Slow because of dynamic memory allocation.
// Returns count written on success and -1 on error.
gms_export double fmod_studio_bank_get_event_list(char *evt_ptr, double capacity, char *gmbuf)
{
    double ret = -1;
    auto bank = (FMOD::Studio::Bank *)evt_ptr;
    if (!bank || !bank->isValid()) return ret;

    int count;
    bank->getBusCount(&count);
    if (count > capacity)
        count = (int)capacity;

    FMOD::Studio::EventDescription **events = new FMOD::Studio::EventDescription * [(int)count];
    check = bank->getEventList(events, count, &count);

    if (check == FMOD_OK)
    {
        ret = (double)count;
        Buffer buf(gmbuf);
        for (int i = 0; i < count; ++i)
        {
            buf.write<uint64_t>((uint64_t)(uintptr_t)events[i]);
        }
    }

    delete[] events;
    return ret;
}

gms_export double fmod_studio_bank_get_string_count(char *ptr)
{
    auto bank = (FMOD::Studio::Bank *)ptr;
    double ret = -1;

    if (bank && bank->isValid())
    {
        int count;
        check = bank->getStringCount(&count);

        if (check == FMOD_OK)
        {
            ret = static_cast<double>(count);
        }
    }

    return ret;
}

// Gets guid from string info. Returns 0 on success and -1 on error.
gms_export double fmod_studio_bank_get_string_info_id(char *ptr, char *gmbuf, double index)
{
    auto bank = (FMOD::Studio::Bank *)ptr;
    double ret = -1;

    if (bank && bank->isValid())
    {
        FMOD_GUID id;
        check = bank->getStringInfo((int)index, &id, nullptr, 0, nullptr);

        Buffer buffer(gmbuf);
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

// Gets path from string info index
gms_export char *fmod_studio_bank_get_string_info_path(char *ptr, double index)
{
    auto bank = (FMOD::Studio::Bank *)ptr;
    static std::string str;

    if (bank && bank->isValid())
    {
        char buffer[PATH_MAX_LENGTH];
        check = bank->getStringInfo((int)index, nullptr, buffer, PATH_MAX_LENGTH, nullptr);
    }

    return const_cast<char *>(str.c_str());
}

// Returns the number of busses or -1 on error.
gms_export double fmod_studio_bank_get_vca_count(char *ptr)
{
    auto bank = (FMOD::Studio::Bank *)ptr;
    double ret = -1;

    if (bank && bank->isValid())
    {
        int count;
        check = bank->getVCACount(&count);
        if (check == FMOD_OK)
        {
            ret = static_cast<double>(count);
        }
    }

    return ret;
}

// Fills a buffer with an array of all the vcas as ptrs cast to uint64.
// Slow because of dynamic memory allocation.
// Returns count written on success and -1 on error.
gms_export double fmod_studio_bank_get_vca_list(char *ptr, double capacity, char *gmbuf)
{
    double ret = -1;
    auto bank = (FMOD::Studio::Bank *)ptr;
    if (!bank || !bank->isValid()) return ret;

    int count;
    bank->getBusCount(&count);
    if (count > capacity)
        count = (int)capacity;

    FMOD::Studio::VCA **vcas = new FMOD::Studio::VCA * [(int)count];
    check = bank->getVCAList(vcas, count, &count);

    if (check == FMOD_OK)
    {
        ret = (double)count;
        Buffer buf(gmbuf);
        for (int i = 0; i < count; ++i)
        {
            buf.write<uint64_t>((uint64_t)(uintptr_t)vcas[i]);
        }
    }

    delete[] vcas;
    return ret;
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
    auto bank = (FMOD::Studio::Bank *)ptr;
    return bank->isValid();
}
