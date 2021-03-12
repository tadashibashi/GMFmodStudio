
function fmod_studio_evdesc_create_instance(
    desc: FMOD.EventDescription): FMOD.EventInstance
{
    desc.createInstance(out);
    return out.val;
}