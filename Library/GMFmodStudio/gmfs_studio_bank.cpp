#include "gmfs_common.h"
#include "gmfs_buffer.h"
#include <iostream>

// Gets the current loading state of a studio bank.
// Returns the loading state enum value or -1 on error.
gms_export double fmod_studio_bank_get_loading_state(char *ptr)
{
    auto bank = (FMOD::Studio::Bank *)ptr;
    double ret = -1;

    if (bank && bank->isValid())
    {
        FMOD_STUDIO_LOADING_STATE state;
        check = bank->getLoadingState(&state);

        if (check == FMOD_OK)
            ret = static_cast<double>(state);
    }

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

// Get bus list: Buffers must be supported to implement this function
// gms_export double fmod_studio_bank_get_bus_list(char *ptr)

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

// Get event list: Buffers must be supported to implement this function
// gms_export double fmod_studio_bank_get_event_list(char *ptr, double capacity, char *gm_buffer)

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

// Get event list: Buffers must be supported to implement this function
// gms_export double fmod_studio_bank_get_vca_list(char *ptr, double capacity, char *gm_buffer)

// TODO:
// getID
// getPath
// setUserData (support strings and doubles)
// getUserData

gms_export double fmod_studio_bank_is_valid(char *ptr)
{
    auto bank = (FMOD::Studio::Bank *)ptr;
    return bank->isValid();
}
