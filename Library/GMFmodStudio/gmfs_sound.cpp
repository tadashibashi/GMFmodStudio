#include "gmfs_common.h"

gms_export double fmod_sound_set_music_speed(char *ptr, double speed)
{
    auto sound = (FMOD::Sound *)ptr;

    check = sound->setMusicSpeed((float)speed);

    return check == FMOD_OK ? 0 : -1;
}

gms_export double fmod_sound_get_music_speed(char *ptr)
{
    auto sound = (FMOD::Sound *)ptr;
    float speed;
    check = sound->getMusicSpeed(&speed);

    return (check == FMOD_OK) ? (double)speed : 0;
}

gms_export double fmod_sound_set_music_channel_volume(char *ptr, double channel, double volume)
{
    auto sound = (FMOD::Sound *)ptr;

    check = sound->setMusicChannelVolume((int)channel, (float)volume);

    return check == FMOD_OK ? 0 : -1;
}

gms_export double fmod_sound_get_music_channel_volume(char *ptr, double channel)
{
    auto sound = (FMOD::Sound *)ptr;
    float volume;
    check = sound->getMusicChannelVolume((int)channel, &volume);

    return (check == FMOD_OK) ? (double)volume : 0;
}

gms_export double fmod_sound_get_music_num_channels(char *ptr)
{
    auto sound = (FMOD::Sound *)ptr;
    int num;
    check = sound->getMusicNumChannels(&num);

    return (check == FMOD_OK) ? (double)num : -1;
}

