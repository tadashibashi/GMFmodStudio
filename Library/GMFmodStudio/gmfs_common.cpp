#include "gmfs_common.h"
#include <iostream>

// Set global variables
FMOD::Studio::System *studio_system = nullptr;
FMOD::System *core_system = nullptr;
FMOD_RESULT check = FMOD_OK;

// Receives callback function pointers for desktop platforms
gms_export void RegisterCallbacks(char *arg1, char *arg2, char *arg3, char *arg4)
{
    GM_API::Init(arg1, arg2, arg3, arg4);
}
