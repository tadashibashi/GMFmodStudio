function fmod_studio_evinst_start(inst: FMOD.EventInstance): void
{
    check = inst.start();
}

function fmod_studio_evinst_stop(inst: FMOD.EventInstance,
    mode: FMOD.STUDIO_STOP_MODE = FMOD.STUDIO_STOP_MODE.ALLOWFADEOUT): void
{
    check = inst.stop(mode);
}

function fmod_studio_evinst_release(inst: FMOD.EventInstance)
{
    check = inst.release();
}

function fmod_studio_evinst_is_valid(inst: FMOD.EventInstance): boolean
{
    return inst.isValid();
}
