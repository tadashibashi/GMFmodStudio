#include "gmfs_common.h"
#include <string>

typedef FMOD::Studio::VCA StudioVCA;

gms_export void fmod_studio_vca_set_volume(char *ptr, double volume)
{
    check = ((StudioVCA *)ptr)->setVolume((float)volume);
}

gms_export double fmod_studio_vca_get_volume(char *ptr)
{
    float volume{ };
    check = ((StudioVCA *)ptr)->getVolume(&volume);

    return static_cast<double>(volume);
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
    return ((StudioVCA *)ptr)->isValid();
}
