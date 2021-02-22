// Clean up FMOD Studio
fmod_studio_system_unload_all(studio);
fmod_studio_system_flush_commands(studio);
fmod_studio_system_release(studio);
