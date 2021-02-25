// Clean up FMOD Studio
fmod_studio_system_unload_all(studio);
fmod_studio_system_flush_commands(studio);
fmod_studio_system_release(studio);

GMFMS_Assert(fmod_studio_system_is_valid(studio), false, "Studio System Release");

delete perf;
