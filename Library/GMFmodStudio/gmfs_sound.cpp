#include "gmfs_common.h"

gms_export double fmod_sound_set_music_speed(char *ptr, double speed)
{
    double ret = -1;
    auto sound = (FMOD::Sound *)ptr;

    check = sound->setMusicSpeed((double)speed);

    return ret;
}
