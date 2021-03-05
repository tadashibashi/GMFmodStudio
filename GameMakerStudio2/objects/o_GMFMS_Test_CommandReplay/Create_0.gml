// Inherit the parent event
event_inherited();

timer = 0;
com = 0;
recd_create_instance_callback = false;
recd_frame_callback = false;
recd_load_bank_callback = false;

function test()
{
	// Initialize the Command Replay Object
	fmod_studio_system_stop_command_capture(studio);
	GMFMS_Check("Stopped Command Capture");
	
	fmod_studio_system_flush_commands(studio);
	
	com = GMFMOD_Ptr(fmod_studio_system_load_command_replay(
		studio, 
		working_directory + "commandcapture.file", 
		FMOD_STUDIO_COMMANDREPLAY_NORMAL));
	GMFMS_Check("Loading CommandReplay");
	GMFMS_Assert(fmod_studio_comreplay_is_valid(com), true,
		"ComReplay Loaded and is Valid");
	// ===========================================================================
	// ComReplay Set Bank Path
	// ===========================================================================
	// Setting it to the same one, but checking that it was indeed set
	fmod_studio_comreplay_set_bank_path(com, working_directory + "soundbanks/Desktop/");
	GMFMS_Check("Set Bank Path");
	
	// ===========================================================================
	// ComReplay Start/Stop/GetPlaybackState
	// ===========================================================================
	// Start
	fmod_studio_comreplay_start(com);
	GMFMS_Check("ComReplay Start: no errors");
	
	GMFMS_Assert(
		fmod_studio_comreplay_get_playback_state(com), // Get Playback State
		FMOD_STUDIO_PLAYBACK_PLAYING,
		"ComReplay Start: is playing");
	GMFMS_Check("ComReplay GetPlaybackState: no errors");
	
	// Stop
	fmod_studio_comreplay_stop(com);
	GMFMS_Check("ComReplay Stop: no errors");
	
	GMFMS_Assert(
		fmod_studio_comreplay_get_playback_state(com), // Get Playback State
		FMOD_STUDIO_PLAYBACK_STOPPED,
		"ComReplay Stop: is stopped");
	
	fmod_studio_system_flush_commands(studio);
	
	// ===========================================================================
	// ComReplay Seek To Command/Get Current Command
	// ===========================================================================
	fmod_studio_comreplay_start(com);
	GMFMS_Check("Comreplay Start: Testing Seek To Command/Get Current Command");

	fmod_studio_system_flush_commands(studio);
	
	fmod_studio_comreplay_seek_to_command(com, 2);
	GMFMS_Check("ComReplay SeekToCommand: no errors");
	
	fmod_studio_comreplay_stop(com);
	GMFMS_Check("Comreplay Stop: Testing Seek To Command/Get Current Command");
	
	fmod_studio_system_flush_commands(studio);
	
	// ===========================================================================
	// ComReplay Seek To Time/Get Current Time
	// ===========================================================================
	
	fmod_studio_comreplay_start(com);
	
	fmod_studio_system_flush_commands(studio);
	
	fmod_studio_comreplay_seek_to_time(com, .5);
	GMFMS_Check("ComReplay Seek to Time");
	
	// Asynchronous, so we will wait until the value changes
	while(fmod_studio_comreplay_get_current_command_time(com) <= 0)
	{
		fmod_studio_system_update(studio);
	}
	
	// This is rough since it tracks the current command's start time, which are
	// not clean integers.
	GMFMS_Assert(fmod_studio_comreplay_get_current_command_time(com) >= .5, true, 
		"ComReplay Seek to Time");
	
	fmod_studio_comreplay_stop(com);
	fmod_studio_system_flush_commands(studio);
	
	// ===========================================================================
	// ComReplay Get Command At Time
	// ===========================================================================
	GMFMS_Assert(
		fmod_studio_comreplay_get_command_at_time(com, .5) > 0,
		true,
		"ComReplay Get Command At Time: command index received");
	GMFMS_Check("ComReplay Get Command At Time: no errors");
	
	// ===========================================================================
	// ComReplay Set/Get Pause
	// ===========================================================================
	// true
	fmod_studio_comreplay_set_paused(com, true);
	GMFMS_Check("Setting Command Replay Paused");
	
	GMFMS_Assert(
		fmod_studio_comreplay_get_paused(com),
		true,
		"ComReplay Paused: true");
	GMFMS_Check("Getting Command Replay Paused");
	
	// false
	fmod_studio_comreplay_set_paused(com, false);
	GMFMS_Check("Setting Command Replay Paused");
	
	GMFMS_Assert(
		fmod_studio_comreplay_get_paused(com),
		false,
		"ComReplay Paused: false");
	GMFMS_Check("Getting Command Replay Paused");
	
	// ===========================================================================
	// ComReplay Get Command Count
	// ===========================================================================
	GMFMS_Assert(fmod_studio_comreplay_get_command_count(com) > 0, true, 
		"Command Count > 0");
	GMFMS_Check("Getting Command Replay Count");
	
	// ===========================================================================
	// ComReplay Get Command Info
	// ===========================================================================
	var buf = GMFMOD_GetBuffer();
	fmod_studio_comreplay_get_command_info(com, 0, buf.getAddress());
	GMFMS_Check("ComReplay Get Command Info");
	
	// Check that numbers are not the default error values.
	var cinfo = new GMFMOD_STUDIO_COMMAND_INFO(buf);
	GMFMS_Assert(cinfo.commandname != "", true,
		"Get Command Info: commandname received");
	GMFMS_Assert(cinfo.framenumber != -1, true,
		"Get Command Info: framenumber received");
	GMFMS_Assert(cinfo.frametime != -1, true,
		"Get Command Info: frametime received");
	
	// ===========================================================================
	// ComReplay Get Command String
	// ===========================================================================
	GMFMS_Assert(
		string_length(fmod_studio_comreplay_get_command_string(com, 4)) > 0,
		true,
		"ComReplay GetCommandString: this is a string with substance");
	GMFMS_Check("ComReplay GetCommandString: no errors");
	
	// ===========================================================================
	// ComReplay Get Length
	// ===========================================================================
	GMFMS_Assert(
		fmod_studio_comreplay_get_length(com) > 0,
		true,
		"Command Length Received");
	GMFMS_Check("ComReplay Get Length");
	
	// ===========================================================================
	// ComReplay Get System
	// ===========================================================================
	GMFMS_Assert(
		GMFMOD_Ptr(fmod_studio_comreplay_get_system(com)) == studio,
		true,
		"ComReplay Get System matches");
	GMFMS_Check("ComReplay Get System");
	
	// ===========================================================================
	// ComReplay Set Callbacks
	// ===========================================================================
	fmod_studio_comreplay_set_create_instance_callback(com);
	GMFMS_Check("ComReplay Set Create Instance Callback");	
	fmod_studio_comreplay_set_frame_callback(com);
	GMFMS_Check("ComReplay Set Frame Callback");	
	fmod_studio_comreplay_set_load_bank_callback(com);
	GMFMS_Check("ComReplay Set Load Bank Callback");
	
	fmod_studio_comreplay_start(com);
}

// Preliminary Bank Loading
fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL);
	
fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.strings.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL);

// Start capturing on creation. Test session will happen in the step event.
fmod_studio_system_start_command_capture(
	studio, 
	working_directory + "commandcapture.file", 
	FMOD_STUDIO_COMMANDCAPTURE_NORMAL);
GMFMS_Check("Started Command Capture");

var evdesc = GMFMOD_Ptr(fmod_studio_system_get_event(studio, "event:/Music"));
GMFMS_Check("Get Music Event");
eimusic = GMFMOD_Ptr(fmod_studio_evdesc_create_instance(evdesc));
GMFMS_Check("Create Music Event Instance");