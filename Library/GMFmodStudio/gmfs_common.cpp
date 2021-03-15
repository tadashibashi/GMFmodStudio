#include "gmfs_common.h"
#include <iostream>

#if defined(_WIN32) || defined(WIN32)
#include <windows.h>
#endif

// Set global variables
FMOD_RESULT check = FMOD_OK;

// Receives callback function pointers for desktop platforms
gms_export void RegisterCallbacks(char *arg1, char *arg2, char *arg3, char *arg4)
{
    GM_API::Init(arg1, arg2, arg3, arg4);

    // Cross-platform Initialization
#if defined(_WIN32) || defined(WIN32)
    CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);
#endif
}

gms_export void GMFMOD_ShutdownIntegration()
{
    // Cross-platform clean up
#if defined(_WIN32) || defined(WIN32)
    CoUninitialize();
#endif
}

gms_export double GMFMOD_IntegrationInitialized()
{
    return 1;
}
