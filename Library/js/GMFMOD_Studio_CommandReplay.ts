function fmod_studio_comreplay_is_valid(comrep: FMOD.CommandReplay): boolean
{
    return comrep !== undefined && comrep.isValid();
}

function fmod_studio_comreplay_release(comrep: FMOD.CommandReplay): void
{
    check = comrep.release();
}