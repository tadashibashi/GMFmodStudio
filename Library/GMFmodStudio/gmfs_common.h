#pragma once
#include <fmod_studio.hpp>

// Define the dynamic library function export macro
#if defined(WIN32) || defined(_WIN32) || defined(__WIN32__) || defined(__NT__)
    #define gms_export extern "C" __declspec (dllexport)
#elif defined(__APPLE__)
    #define gms_export extern "C"
#elif defined (__linux__) || defined (__unix__)
    #define gms_export __attribute__((visibility("default")))
#endif

#include "gmfs_api.h"

// TODO: Custom error checker
extern FMOD_RESULT check;
