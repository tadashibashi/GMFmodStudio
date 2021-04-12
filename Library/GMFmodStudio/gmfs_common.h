#pragma once
#include <fmod_studio.hpp>
#include <string>
#include "gmfs_buffer.h"
// Define the dynamic library function export macro
#if defined(WIN32) || defined(_WIN32) || defined(__WIN32__) || defined(__NT__)
    #define gms_export extern "C" __declspec (dllexport)
#elif defined(__APPLE__)
    #define gms_export extern "C"
#elif defined (__linux__) || defined (__unix__)
    #define gms_export extern "C" __attribute__((visibility("default")))
#endif

#include "gmfs_api.h"

// TODO: Custom error checker

extern FMOD_RESULT check;

const int PATH_MAX_LENGTH = 100;

template <typename T>
double fmod_studio_obj_get_id(char *ptr, char *gmbuf)
{
    auto obj = (T *)ptr;
    double ret = -1;

    if (obj && obj->isValid())
    {
        FMOD_GUID id;
        check = obj->getID(&id);
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

template <typename T>
char *fmod_studio_obj_get_path(char *ptr)
{
    static std::string str;

    auto obj = (T *)ptr;

    if (obj && obj->isValid())
    {
        char path[PATH_MAX_LENGTH];
        check = obj->getPath(path, PATH_MAX_LENGTH, nullptr);
        if (check == FMOD_OK)
        {
            str.assign(path);
        }
    }

    return const_cast<char *>(str.c_str());
}
