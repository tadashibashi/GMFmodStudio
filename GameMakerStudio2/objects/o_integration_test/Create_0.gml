/// @description Insert description here
// You can write your code in this editor
studio = new FmodStudioSystem(); /// @is FmodStudioSystem

studio.initialize(128, FMOD_STUDIO_INIT_LIVEUPDATE, 0);
show_debug_message(fmod_studio_get_error_string());
studio.loadBankFile(working_directory + "soundbanks/Desktop/Master.bank");
show_debug_message(fmod_studio_get_error_string());
studio.loadBankFile(working_directory + "soundbanks/Desktop/Master.strings.bank");
show_debug_message(fmod_studio_get_error_string());
desc = studio.getEvent("event:/Music");
show_debug_message(fmod_studio_get_error_string());

desc.getUserProperty("num_prop").log();
desc.getUserProperty("string_prop").log();

descID = desc.getID();
descID.log();
descGottenByID = studio.getEventByID(descID);

var paramdesc/*: FmodStudioParameterDescription*/ = 
    desc.getParameterDescriptionByName("Pitch");

var paramID = paramdesc.id;
var paramdesc2 = desc.getParameterDescriptionByID(paramID);
paramdesc2.log();

inst = descGottenByID.createInstance();
inst2 = studio.getEvent("event:/UIBlip").createInstance();

inst.start();

image_xscale = 4;
image_yscale = 4;

target_xscale = image_xscale;
target_yscale = image_yscale;
