/// @description Insert description here
// You can write your code in this editor
studio = new FmodStudioSystem(); /// @is FmodStudioSystem
studio.initialize(128, FMOD_STUDIO_INIT_LIVEUPDATE, 0);
studio.loadBankFile(working_directory + "soundbanks/Desktop/Master.bank");
studio.loadBankFile(working_directory + "soundbanks/Desktop/Master.strings.bank");
desc = studio.getEvent("event:/Music");

descID = desc.getID();
descGottenByID = studio.getEventByID(descID);

var paramdesc/*: FmodStudioParameterDescription*/ = 
    desc.getParameterDescriptionByName("Pitch");

var paramID = paramdesc.id;
var paramdesc2 = desc.getParameterDescriptionByID(paramID);

inst = descGottenByID.createInstance();

inst2 = studio.getEvent("event:/UIBlip").createInstance();

//inst.start();

fmod_studio_system_start_command_capture(studio.studio_, working_directory + "commandtest.file", 0);

var sound = ptr(fmod_system_create_midi_sound(studio.core_, 
	working_directory + "disney.mid", working_directory + "Fury.dls", 0));
//fmod_system_play_sound(studio.core_, sound);

inst.start();

image_xscale = 4;
image_yscale = 4;

target_xscale = image_xscale;
target_yscale = image_yscale;

target_alpha = 1;

crep = pointer_null;