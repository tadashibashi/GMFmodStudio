/// @description Insert description here
// You can write your code in this editor
inst.stop(1);

fmod_studio_system_stop_command_capture(studio.studio_);

if (crep == pointer_null)
	crep = ptr(fmod_studio_system_load_command_replay(studio.studio_, working_directory + "commandtest.file", 0));

fmod_studio_comreplay_set_frame_callback(crep);
fmod_studio_comreplay_set_create_instance_callback(crep);
fmod_studio_comreplay_set_load_bank_callback(crep);

studio.flushCommands();

fmod_studio_comreplay_start(crep);
