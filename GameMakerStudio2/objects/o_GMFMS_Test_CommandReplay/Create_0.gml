// Inherit the parent event
event_inherited();

timer = 0;
cmd = 0;

function test()
{
	// Initialize the Command Replay Object
	fmod_studio_system_stop_command_capture(studio);
	GMFMS_Check("Stopped Command Capture");
	
	fmod_studio_system_flush_commands(studio);
	
	cmd = GMFMS_Ptr(fmod_studio_system_load_command_replay(
		studio, 
		"commandcapture", 
		FMOD_STUDIO_COMMANDCAPTURE_NORMAL));
	
	GMFMS_Assert(fmod_studio_comreplay_is_valid(cmd), true,
		"ComReplay Loaded and is Valid");
	
	// TODO: COMREPLAY TESTS. . . . .
	
	
	// Clean up the Command Replay Object
	fmod_studio_comreplay_release(cmd);
	fmod_studio_system_flush_commands(studio);
	
	GMFMS_Assert(fmod_studio_comreplay_is_valid(cmd), false,
		"ComReplay Released");
	
	finish();
}

// Start capturing on creation. Test session will happen in the step event.
fmod_studio_system_start_command_capture(
	studio, 
	"commandcapture", 
	FMOD_STUDIO_COMMANDCAPTURE_NORMAL);
GMFMS_Check("Started Command Capture");
