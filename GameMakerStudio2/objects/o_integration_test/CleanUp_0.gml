/// @description Insert description here
// You can write your code in this editor
inst.release();
inst2.release();

studio.flushCommands();
studio.unloadAll();

studio.release();

global.__fmod_studio_extension_buffer.release();

fmod_studio_system_stop_command_capture(studio.studio_);