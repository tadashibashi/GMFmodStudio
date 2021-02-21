#include "gmfs_common.h"
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
    return fmod_studio_obj_get_id<FMOD::Studio::VCA>(ptr, gmbuf);
}

gms_export char *fmod_studio_vca_get_path(char *ptr)
{
    return fmod_studio_obj_get_path<FMOD::Studio::VCA>(ptr);
}

gms_export double fmod_studio_vca_is_valid(char *ptr)
{
    auto vca = (FMOD::Studio::VCA *)ptr;
    return vca->isValid();
}
