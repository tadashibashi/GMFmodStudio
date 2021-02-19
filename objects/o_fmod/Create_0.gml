/// @description Insert description here
// You can write your code in this editor

studio = fmod_studio_system_create();

fmod_studio_system_initialize(studio, 128, true);
fmod_studio_system_load_bank_file(studio, working_directory + "soundbanks/Desktop/Master.bank");
show_debug_message(fmod_studio_get_error_string());
fmod_studio_system_load_bank_file(studio, working_directory + "soundbanks/Desktop/Master.strings.bank");
show_debug_message(fmod_studio_get_error_string());

desc = fmod_studio_system_get_event(studio, "event:/Music");
desc2 = fmod_studio_system_get_event(studio, "event:/UIBlip");
str = fmod_studio_evdesc_get_path(desc);
inst = fmod_studio_evdesc_create_instance(desc);
fmod_studio_evinst_start(inst);