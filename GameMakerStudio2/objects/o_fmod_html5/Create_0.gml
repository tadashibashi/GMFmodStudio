/// @description Insert description here
// You can write your code in this editor

studio = new GMFMOD_Studio_System(); /// @is {GMFMOD_Studio_System}

studio.initialize(128, FMOD_STUDIO_INIT_NORMAL, FMOD_INIT_NORMAL);
GMFMOD_Check("Initializing Studio System");

studio.loadBankFile("soundbanks/Desktop/Master_ENG.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL);
GMFMOD_Check("Loading bank file");
studio.loadBankFile("soundbanks/Desktop/Master_ENG.strings.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL);
GMFMOD_Check("Loading string bank file");

evdblip = studio.getEvent("event:/UIBlip"); /// @is {GMFMOD_Studio_EventDescription}
GMFMOD_Check("Getting event");

evinst = evdblip.createInstance(); /// @is {GMFMOD_Studio_EventInstance}
GMFMOD_Check("Creating instance");

evinst.setCallback(FMOD_STUDIO_EVENT_CALLBACK_ALL);
GMFMOD_Check("Setting callback");

// Event Description Tests
GMFMOD_Assert(evdblip.getInstanceCount(), 1, "One event instance");
GMFMOD_Check("getting event instance count");


