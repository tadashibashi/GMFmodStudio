
studio = new GMFMS_System(); /// @is GMFMS_System
studio.initialize(128, FMOD_STUDIO_INIT_LIVEUPDATE, 0);
studio.loadBankFile(working_directory + "soundbanks/Desktop/Master_ENG.bank", FMOD_STUDIO_LOAD_BANK_NONBLOCKING);
studio.loadBankFile(working_directory + "soundbanks/Desktop/Master_ENG.strings.bank", FMOD_STUDIO_LOAD_BANK_NONBLOCKING);
desc = studio.getEvent("event:/Music");
audioTableDesc = studio.getEvent("event:/AudioTable");

descID = desc.getID();
descGottenByID = studio.getEventByID(descID);

var paramdesc/*: GMFMS_ParamDesc*/ = 
    desc.getParamDescByName("Pitch");

var paramID = paramdesc.pid;
var paramdesc2 = desc.getParamDescByID(paramID);

inst = new GMFMS_EvInst();
descGottenByID.createInstance(inst);

inst2 = studio.getEvent("event:/UIBlip").createInstance();

audioTableInst = audioTableDesc.createInstance();
audioTableInst.setCallbackAudioTable(studio.getHandle());

tabletest = studio.createAudioTableInst("event:/AudioTable", "Explode");

fmod_studio_system_start_command_capture(studio.studio_, working_directory + "commandtest.file", 0);

soundspeed = 1;
sound = ptr(fmod_system_create_midi_sound(studio.core_, 
	working_directory + "disney.mid", working_directory + "Fury.dls", 0));



image_xscale = 4;
image_yscale = 4;

target_xscale = image_xscale;
target_yscale = image_yscale;

target_alpha = 1;

crep = pointer_null;
