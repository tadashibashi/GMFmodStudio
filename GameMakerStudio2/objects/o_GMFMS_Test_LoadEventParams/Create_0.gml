// Inherit the parent event
event_inherited();
timer = 0;
checkedParamByName = false;
stopped = false;

// ============================================================================
// Bank Load File Test
// ============================================================================
bank = ptr(fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.bank",
	FMOD_STUDIO_LOAD_BANK_NONBLOCKING));

// Make sure to load the strings bank before loading any FMOD Studio 
// objects via paths. E.g. get event won't work.
stringsbank = ptr(fmod_studio_system_load_bank_file(studio,
	working_directory + "soundbanks/Desktop/Master_ENG.strings.bank",
	FMOD_STUDIO_LOAD_BANK_NONBLOCKING));

// Process bank metadata loading immediately.
fmod_studio_system_flush_commands(studio);
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "Studio System Flush Commands");

// Stall until bank metadata has loaded.
var loadingstate, strloadingstate;
do {
	loadingstate = fmod_studio_bank_get_loading_state(bank);
	strloadingstate = fmod_studio_bank_get_loading_state(stringsbank);
	show_debug_message("Waiting for banks to load. . . ");
}
until(loadingstate == FMOD_STUDIO_LOADING_STATE_LOADED &&
   strloadingstate == FMOD_STUDIO_LOADING_STATE_LOADED);

show_debug_message("[Bank Files Loaded] PASSED.");

// ============================================================================
// Bank Load Sample Data Test
// ============================================================================
fmod_studio_bank_load_sample_data(bank);

// Process sample loading immediately, and stall until loading is finished.
fmod_studio_system_flush_sample_loading(studio);
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "Studio System Flush Sample Loading");

// Check that the samples have successfully loaded.
GMFMS_Assert(fmod_studio_bank_get_sample_loading_state(bank), 
	FMOD_STUDIO_LOADING_STATE_LOADED, "Bank Load Sample Data");

// ============================================================================
// Get Event Description by Path Test
// ============================================================================
evdesc = ptr(fmod_studio_system_get_event(studio, "event:/Music"));

GMFMS_Assert(fmod_studio_evdesc_is_valid(evdesc), true, 
	"Get Event Description by Path");

// ============================================================================
// Create Event Instance from Event Description
// ============================================================================
evinst = ptr(fmod_studio_evdesc_create_instance(evdesc));

GMFMS_Assert(fmod_studio_evinst_is_valid(evinst), true,
	"Create Event Instance from Description");

// ============================================================================
// Start Event Instance
// ============================================================================
fmod_studio_evinst_start(evinst);

fmod_studio_system_flush_commands(studio);

var playbackstate;
do {
	playbackstate = fmod_studio_evinst_get_playback_state(evinst);
} until (playbackstate == FMOD_STUDIO_PLAYBACK_PLAYING);

show_debug_message("[Start Event Instance] PASSED.");

// ============================================================================
// Get ParamDescription By Name
// ============================================================================
var buf = GMFMS_GetBuffer();
fmod_studio_evdesc_get_paramdesc_by_name(evdesc, "Pitch", buf.getAddress());
paramdesc_pitch = new GMFMS_ParamDesc(buf);

// Check that each field is as expected.
GMFMS_Assert(paramdesc_pitch.name, "Pitch", "ParamDesc Get Name");
GMFMS_Assert(paramdesc_pitch.minimum, 0, "ParamDesc Get Minimum");
GMFMS_Assert(paramdesc_pitch.maximum, 1, "ParamDesc Get Maximum");
GMFMS_Assert(paramdesc_pitch.defaultvalue, 0.5, "ParamDesc Get Default");
GMFMS_Assert(paramdesc_pitch.flags, 0, "ParamDesc Get Flags");

buf.seekReset();

// ============================================================================
// Get ParamDescription By ID
// ============================================================================
paramdesc_pitch.pid.writeToBuffer(buf);
fmod_studio_evdesc_get_paramdesc_by_id(evdesc, buf.getAddress());
buf.seekReset();

var paramdesc_pitch_by_id = new GMFMS_ParamDesc(buf);

// Check that each field is as expected.
GMFMS_Assert(paramdesc_pitch_by_id.name, "Pitch", "ParamDesc by ID Get Name");
GMFMS_Assert(paramdesc_pitch_by_id.minimum, 0, "ParamDesc by ID Get Minimum");
GMFMS_Assert(paramdesc_pitch_by_id.maximum, 1, "ParamDesc by ID Get Maximum");
GMFMS_Assert(paramdesc_pitch_by_id.defaultvalue, 0.5, "ParamDesc by ID Get Default");
GMFMS_Assert(paramdesc_pitch_by_id.flags, 0, "ParamDesc by ID Get Flags");

delete paramdesc_pitch_by_id;
