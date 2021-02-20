#include "gmfs_common.h"
#include "gmfs_buffer.h"
#include <string>

gms_export double fmod_studio_vca_set_volume(char *ptr, double volume)
{
    auto vca = (FMOD::Studio::VCA *)ptr;
    double ret = -1;

    if (vca && vca->isValid())
    {
        check = vca->setVolume((float)volume);

        if (check == FMOD_OK)
            ret = 0;
    }

    return ret;
}

gms_export double fmod_studio_vca_get_volume(char *ptr)
{
    auto vca = (FMOD::Studio::VCA *)ptr;
    double ret = -1;

    if (vca && vca->isValid())
    {
        float volume;
        check = vca->getVolume(&volume);

        if (check == FMOD_OK)
            ret = (double)volume;
    }

    return ret;
}

gms_export double fmod_studio_vca_get_id(char *ptr, char *gmbuf)
{
    auto vca = (FMOD::Studio::VCA *)ptr;
    double ret = -1;

    if (vca && vca->isValid())
    {
        FMOD_GUID id;
        check = vca->getID(&id);
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

gms_export char *fmod_studio_vca_get_path(char *ptr)
{
    static std::string str;
    
    auto vca = (FMOD::Studio::VCA *)ptr;

    if (vca && vca->isValid())
    {
        char path[100];
        check = vca->getPath(path, 100, nullptr);
        if (check == FMOD_OK)
        {
            str.assign(path);
        }
    }

    return const_cast<char *>(str.c_str());
}

gms_export double fmod_studio_vca_is_valid(char *ptr)
{
    auto vca = (FMOD::Studio::VCA *)ptr;
    return vca->isValid();
}
