/// @description CommandReplay General Tests
event_inherited();

timer = 0;
received_createinst_callback = false;
received_frame_callback = false;
received_load_bank_callback = false;
comrep = /*#cast*/ pointer_null; /// @is {GMFMOD_Studio_CommandReplay}

// Preliminary bank loading
bank = studio.loadBankFile("soundbanks/Desktop/Master_ENG.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL);
GMFMOD_Check("Loading master bank");

stringsbank = studio.loadBankFile("soundbanks/Desktop/Master_ENG.strings.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL);
GMFMOD_Check("Loading master strings bank");

evdmusic = studio.getEvent("event:/Music");
GMFMOD_Check("Getting music event");
evdblip = studio.getEvent("event:/UIBlip");
GMFMOD_Check("Getting blip event");
GMFMOD_Assert(evdmusic.isValid(), true, "EvDesc Is Valid 1");
GMFMOD_Assert(evdblip.isValid(), true, "EvDesc Is Valid 2");

instmusic = evdmusic.createInstance(); /// @is {GMFMOD_Studio_EventInstance}
GMFMOD_Check("Creating music instance");
instblip  = evdblip.createInstance();  /// @is {GMFMOD_Studio_EventInstance}
GMFMOD_Check("Creating blip instance");
GMFMOD_Assert(instmusic.isValid(), true, "Music instance is valid");
GMFMOD_Assert(instblip.isValid(), true, "Blip instance is valid");

studio.startCommandCapture("command.capture", FMOD_STUDIO_COMMANDCAPTURE_NORMAL);
GMFMOD_Check("Starting command capture");

function test()
{
	studio.stopCommandCapture();
	GMFMOD_Check("Stopping command capture");
	
	studio.flushCommands();
	GMFMOD_Check("Flushing commands");
	
	comrep = studio.loadCommandReplay("command.capture", 
		FMOD_STUDIO_COMMANDCAPTURE_NORMAL);
	GMFMOD_Check("Loading command replay");
	GMFMOD_Assert(comrep.isValid(), true, "Command replay is valid");
	
	// ===== Set Bank Path =====
	comrep.setBankPath("soundbanks/Desktop");
	GMFMOD_Check("Setting bank path");
	
	// ===== Start/Stop/GetPlaybackState =====
	comrep.start();
	GMFMOD_Check("Starting command replay");
	
	GMFMOD_Assert(comrep.getPlaybackState(), FMOD_STUDIO_PLAYBACK_PLAYING,
		"Playback is playing");
	
	comrep.stop();
	GMFMOD_Check("Stopping command replay");
	
	GMFMOD_Assert(comrep.getPlaybackState(), FMOD_STUDIO_PLAYBACK_STOPPED,
		"Playback is stopped");
	
	studio.flushCommands();
	GMFMOD_Check("Flushing commands");
	
	// ===== Seek to command / Get current command =====
	comrep.start();
	GMFMOD_Check("Starting command replay");
	
	studio.flushCommands();
	GMFMOD_Check("Flushing commands");
	
	comrep.seekToCommand(2);
	GMFMOD_Check("Seeking to command 2");
	
	comrep.stop();
	GMFMOD_Check("Stopping command replay");
	
	studio.flushCommands();
	GMFMOD_Check("Flushing commands");
	
	// ===== Seek to time / Get current time =====
	comrep.start();
	GMFMOD_Check("Starting command replay");
	
	studio.flushCommands();
	GMFMOD_Check("Flushing commands");
	
	comrep.seekToTime(.5);
	GMFMOD_Check("Seeking to time");
	
	comrep.stop();
	GMFMOD_Check("Stopping command replay");
	
	studio.flushCommands();
	GMFMOD_Check("Flushing commands");
	
	// ===== Getting command at time =====
	GMFMOD_Assert(is_numeric(comrep.getCommandAtTime(.05)), true, 
		"Command index retrieved is numeric");
	GMFMOD_Assert(is_numeric(comrep.getCommandAtTime(.05)) > 0, true, 
		"Command index is greater than 0");
	GMFMOD_Check("Getting command at time 0.5");
	
	// ===== Set/Get Pause =====
	comrep.setPaused(true);
	GMFMOD_Check("Setting paused: true");
	
	GMFMOD_Assert(comrep.getPaused(), true, "Paused is as set: true");
	GMFMOD_Check("Getting paused");
	
	comrep.setPaused(false);
	GMFMOD_Check("Setting paused: false");
	
	GMFMOD_Assert(comrep.getPaused(), false, "Paused is as set: false");
	GMFMOD_Check("Getting paused");
	
	// ===== Get Command Count =====
	GMFMOD_Assert(is_numeric(comrep.getCommandCount()), true, 
		"Command Count is numeric");
	GMFMOD_Check("Getting command count");
	GMFMOD_Assert(comrep.getCommandCount() > 0, true, "Command Count > 0");
	GMFMOD_Check("Getting command count");
	
	// ===== Get Command Info =====
	// pass by ref
	var cinfo = new GMFMOD_STUDIO_COMMAND_INFO();
	comrep.getCommandInfo(0, cinfo);
	GMFMOD_Check("Getting command info: pass by ref");
	
	GMFMOD_Assert(cinfo.commandname != "", true,
		"Get Command Info: commandname received");
	GMFMOD_Assert(cinfo.framenumber != -1, true,
		"Get Command Info: framenumber received");
	GMFMOD_Assert(cinfo.frametime != -1, true,
		"Get Command Info: frametime received");
	delete cinfo;
	
	// create new returned
	var cinfo = comrep.getCommandInfo(0);
	GMFMOD_Check("Getting command info: return new");
	
	GMFMOD_Assert(instanceof(cinfo) == "GMFMOD_STUDIO_COMMAND_INFO",
		true, "getCommandInfo returns correct type");
	
	GMFMOD_Assert(cinfo.commandname != "", true,
		"Get Command Info: commandname received");
	GMFMOD_Assert(cinfo.framenumber != -1, true,
		"Get Command Info: framenumber received");
	GMFMOD_Assert(cinfo.frametime != -1, true,
		"Get Command Info: frametime received");
	delete cinfo;
	
	// ===== Get Command String ====
	GMFMOD_Assert(string_length(comrep.getCommandString(4)) > 0, true,
		"Get command string returns a string of substance");
	GMFMOD_Check("Getting command string");
	
	// ===== Get Length =====
	GMFMOD_Assert(comrep.getLength() > 0, true, "Command length received");
	GMFMOD_Check("Getting length");
	
	// ===== Get System =====
	GMFMOD_Assert(instanceof(comrep.getSystem()) == "GMFMOD_Studio_System",
		true, "Returns a Studio System type wrapper object");
	GMFMOD_Assert(comrep.getSystem().isValid(), true, 
		"Contains valid studio system wrapper object");
	
	// ===== Set Callbacks =====
	comrep.setFrameCallback();
	GMFMOD_Check("Setting frame callback");
	comrep.setLoadBankCallback();
	GMFMOD_Check("Setting load bank callback");
	comrep.setCreateInstanceCallback();
	GMFMOD_Check("Setting create instance callback");
	
	comrep.start();
	GMFMOD_Check("Starting command replay");
}