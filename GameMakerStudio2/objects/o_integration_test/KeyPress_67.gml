/// @description Insert description here
// You can write your code in this editor

fmod_studio_system_stop_command_capture(studio.studio_);

var crep = ptr(fmod_studio_system_load_command_replay(studio.studio_, working_directory + "commandtest.file", 0));

inst.stop();

fmod_studio_comreplay_start(crep);
