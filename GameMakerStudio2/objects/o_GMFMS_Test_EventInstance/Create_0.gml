event_inherited();

fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL);
	
fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.strings.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL);


evdmusic = GMFMS_Ptr(fmod_studio_system_get_event(studio, "event:/Music"));
evdblip = GMFMS_Ptr(fmod_studio_system_get_event(studio, "event:/UIBlip"));

evimusic = GMFMS_Ptr(fmod_studio_evdesc_create_instance(evdmusic));
eviblip = GMFMS_Ptr(fmod_studio_evdesc_create_instance(evdblip));

GMFMS_Assert(fmod_studio_evinst_is_valid(evimusic), true, "EvInst is valid 1");
GMFMS_Assert(fmod_studio_evinst_is_valid(eviblip), true, "EvInst is valid 2");

// ----------------------------------------------------------------------------
// EvInst Start/Stop
// ----------------------------------------------------------------------------
fmod_studio_evinst_start(evimusic);

GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "EvInst Start: no errors");
GMFMS_Assert(fmod_studio_evinst_get_playback_state(evimusic), 
	FMOD_STUDIO_PLAYBACK_STARTING, "EvInst Start: starting");

fmod_studio_system_flush_commands(studio);
GMFMS_Assert(fmod_studio_evinst_get_playback_state(evimusic), 
	FMOD_STUDIO_PLAYBACK_PLAYING, "EvInst Start: playing");

fmod_studio_evinst_stop(evimusic, FMOD_STUDIO_STOP_IMMEDIATE);

GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "EvInst Stop: no errors");
GMFMS_Assert(fmod_studio_evinst_get_playback_state(evimusic), 
	FMOD_STUDIO_PLAYBACK_STOPPING, "EvInst Stop: stopping");

fmod_studio_system_flush_commands(studio);
GMFMS_Assert(fmod_studio_evinst_get_playback_state(evimusic), 
	FMOD_STUDIO_PLAYBACK_STOPPED, "EvInst Stop: stopped");

// ----------------------------------------------------------------------------
// EvInst Set/Get Paused
// ----------------------------------------------------------------------------
fmod_studio_evinst_set_paused(evimusic, true);
GMFMS_Check("EvInst Set Paused: true");

GMFMS_Assert(fmod_studio_evinst_get_paused(evimusic), true,
	"EvInst Get Paused: true");

fmod_studio_evinst_set_paused(evimusic, false);
GMFMS_Check("EvInst Set Paused: false");
GMFMS_Assert(fmod_studio_evinst_get_paused(evimusic), false,
	"EvInst Get Paused: false");

// ----------------------------------------------------------------------------
// EvInst Trigger Cue
// ----------------------------------------------------------------------------
var evdcue = GMFMS_Ptr(fmod_studio_system_get_event(studio, 
	"event:/TestCueEvent"));
var evicue = GMFMS_Ptr(fmod_studio_evdesc_create_instance(evdcue));
fmod_studio_evinst_trigger_cue(evicue);
GMFMS_Check("EvInst Trigger Cue");

fmod_studio_evinst_trigger_cue(eviblip);
GMFMS_Assert(GMFMS_GetError() != FMOD_OK, true,
	"EvInst Trigger Cue: non-cue event causes error");
	
fmod_studio_evinst_release(evicue);

// ----------------------------------------------------------------------------
// EvInst Set/Get Pitch
// ----------------------------------------------------------------------------
fmod_studio_evinst_set_pitch(evimusic, 1);
fmod_studio_evinst_set_pitch(evimusic, 2.34);
GMFMS_Check("EvInst set pitch: no errors");

GMFMS_Assert(fmod_studio_evinst_get_pitch(evimusic), 2.34, 
	"EvInst get pitch: matches set pitch value");
GMFMS_Check("EvInst get pitch: no errors");

 // Must flush commands to see changes in pitch_final function
fmod_studio_system_flush_commands(studio);
var finalpitch = fmod_studio_evinst_get_pitch_final(evimusic);
GMFMS_Check("EvInst get pitch final: no errors");
GMFMS_Assert(finalpitch , 2.34, "EvInst get pitch final");

// ----------------------------------------------------------------------------
// EvInst Set/Get Property
// ----------------------------------------------------------------------------
fmod_studio_evinst_set_property(evimusic, 
	FMOD_STUDIO_EVENT_PROPERTY_CHANNELPRIORITY, 5);
GMFMS_Check("EvInst set property: no errors");
GMFMS_Assert(fmod_studio_evinst_get_property(evimusic, 
	FMOD_STUDIO_EVENT_PROPERTY_CHANNELPRIORITY), 
	5, 
	"EvInst get property: matches set value");
GMFMS_Check("EvInst get property: no errors");

fmod_studio_evinst_set_property(evimusic, 
	FMOD_STUDIO_EVENT_PROPERTY_CHANNELPRIORITY, -5.2);
GMFMS_Assert(GMFMS_GetError(), FMOD_ERR_INVALID_PARAM,
	"EvInst set property: invalid param value passed");
GMFMS_Assert(fmod_studio_evinst_get_property(evimusic, 
	FMOD_STUDIO_EVENT_PROPERTY_CHANNELPRIORITY), 
	5, 
	"EvInst get property: value not altered by invalid param value");
GMFMS_Check("EvInst get property: no errors");

// ----------------------------------------------------------------------------
// EvInst Set/Get Timeline position
// ----------------------------------------------------------------------------
fmod_studio_evinst_set_timeline_position(evimusic, 4.1234);
GMFMS_Check("EvInst set timeline position: no errors");
GMFMS_Assert(fmod_studio_evinst_get_timeline_position(evimusic),  
	0, "EvInst get timeline position, no updates yet");
GMFMS_Check("EvInst get timeline position: no errors");

fmod_studio_system_flush_commands(studio);

GMFMS_Assert(fmod_studio_evinst_get_timeline_position(evimusic),  
	4, "EvInst get timeline position: values match after update. (Truncated int)");

// ----------------------------------------------------------------------------
// EvInst Set/Get Volume
// ----------------------------------------------------------------------------



timer = 0;



