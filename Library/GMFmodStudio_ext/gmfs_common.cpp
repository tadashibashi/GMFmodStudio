#include "gmfs_common.h"
#include <iostream>

// Set global variables
FMOD::Studio::System *studio_system = nullptr;
FMOD::System *core_system = nullptr;
FMOD_RESULT check = FMOD_OK;
 
// Callback-related functions for desktop platforms
void (*CreateAsynEventWithDSMap)(int, int) = nullptr;
int (*CreateDsMap)(int _num, ...) = nullptr;
bool (*DsMapAddDouble)(int _index, const char *_pKey, double value) = nullptr;
bool (*DsMapAddString)(int _index, const char *_pKey, const char *pVal) = nullptr;

// Receives callback function pointers for desktop platforms
gms_export void RegisterCallbacks(char *arg1, char *arg2, char *arg3, char *arg4)
{
    void (*CreateAsynEventWithDSMapPtr)(int, int) = (void (*)(int, int))(arg1);
    int(*CreateDsMapPtr)(int _num, ...) = (int(*)(int _num, ...)) (arg2);
    CreateAsynEventWithDSMap = CreateAsynEventWithDSMapPtr;
    CreateDsMap = CreateDsMapPtr;

    bool (*DsMapAddDoublePtr)(int _index, const char *_pKey, double value) = (bool(*)(int, const char *, double))(arg3);
    bool (*DsMapAddStringPtr)(int _index, const char *_pKey, const char *pVal) = (bool(*)(int, const char *, const char *))(arg4);

    DsMapAddDouble = DsMapAddDoublePtr;
    DsMapAddString = DsMapAddStringPtr;
}
