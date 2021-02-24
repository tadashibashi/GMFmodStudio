// Inherit the parent event
event_inherited();

// Preliminary bank loading
fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL);

fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.strings.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL);

evdmusic = GMFMS_Ptr(fmod_studio_system_get_event(studio, "event:/Music"));
evdblip = GMFMS_Ptr(fmod_studio_system_get_event(studio, "event:/UIBlip"));

// ----------------------------------------------------------------------------
// EvDesc Create Instance
// ----------------------------------------------------------------------------
evimusic = GMFMS_Ptr(fmod_studio_evdesc_create_instance(evdmusic));

GMFMS_Assert(GMFMS_GetError(), FMOD_OK, 
	"EvDesc Create Instance: no errors");
GMFMS_Assert(fmod_studio_evinst_is_valid(evimusic), true, 
	"EvDesc Create Instance: valid instance");

// ----------------------------------------------------------------------------
// EvDesc Get Instance Count
// ----------------------------------------------------------------------------
GMFMS_Assert(fmod_studio_evdesc_get_instance_count(evdmusic), 1,
	"EvDesc Get Instance Count");

// Create two instances
fmod_studio_evdesc_create_instance(evdmusic);
fmod_studio_evdesc_create_instance(evdmusic);

GMFMS_Assert(fmod_studio_evdesc_get_instance_count(evdmusic), 3,
	"EvDesc Get Instance Count: add two instances");

// Release one instance
fmod_studio_evinst_release(evimusic);
fmod_studio_system_flush_commands(studio); // update to affect release now

GMFMS_Assert(fmod_studio_evdesc_get_instance_count(evdmusic), 2,
	"EvDesc Get Instance Count: release one instance");
	
// Release all instances
fmod_studio_evdesc_release_all_instances(evdmusic);
fmod_studio_system_flush_commands(studio);

GMFMS_Assert(fmod_studio_evdesc_get_instance_count(evdmusic), 0,
	"EvDesc Get Instance Count: release all instances");

// ----------------------------------------------------------------------------
// EvDesc Get Instance List
// ----------------------------------------------------------------------------
var buf = GMFMS_GetBuffer();

var inst1 = GMFMS_Ptr(fmod_studio_evdesc_create_instance(evdmusic));
var inst2 = GMFMS_Ptr(fmod_studio_evdesc_create_instance(evdmusic));

var count = fmod_studio_evdesc_get_instance_list(evdmusic, buf.getSize()/8, 
	buf.getAddress());

GMFMS_Assert(count, 2, "EvDesc Get Instance List: count matches");
GMFMS_Assert(GMFMS_Ptr(buf.read(buffer_u64)), inst1, 
	"EvDesc Get Instance List: retrieval match 1");
GMFMS_Assert(GMFMS_Ptr(buf.read(buffer_u64)), inst2, 
	"EvDesc Get Instance List: retrieval match 2");

fmod_studio_evinst_release(inst1);
fmod_studio_evinst_release(inst2);
fmod_studio_system_flush_commands(studio);

// ----------------------------------------------------------------------------
// EvDesc Release All Instances
// ----------------------------------------------------------------------------
var inst1 = GMFMS_Ptr(fmod_studio_evdesc_create_instance(evdmusic));
var inst2 = GMFMS_Ptr(fmod_studio_evdesc_create_instance(evdmusic));

GMFMS_Assert(fmod_studio_evdesc_get_instance_count(evdmusic), 2,
	"EvDesc Release All Instances: add two instances");

fmod_studio_evdesc_release_all_instances(evdmusic);
fmod_studio_system_flush_commands(studio);

GMFMS_Assert(GMFMS_GetError(), FMOD_OK,
	"EvDesc Release All Instances: no errors");
GMFMS_Assert(fmod_studio_evdesc_get_instance_count(evdmusic), 0,
	"EvDesc Release All Instances");

// ----------------------------------------------------------------------------
// EvDesc Load/Unload Sample Data
// ----------------------------------------------------------------------------
fmod_studio_evdesc_load_sample_data(evdmusic);
GMFMS_Assert(GMFMS_GetError(), FMOD_OK,
	"EvDesc Load Sample Data: no errors");
GMFMS_Assert(fmod_studio_evdesc_get_sample_loading_state(evdmusic), 
	FMOD_STUDIO_LOADING_STATE_LOADING, "EvDesc Load Sample Data: Loading");

fmod_studio_system_flush_commands(studio); // update to affect changes now

GMFMS_Assert(fmod_studio_evdesc_get_sample_loading_state(evdmusic), 
	FMOD_STUDIO_LOADING_STATE_LOADED, "EvDesc Load Sample Data: Loaded");

fmod_studio_evdesc_unload_sample_data(evdmusic);
GMFMS_Assert(fmod_studio_evdesc_get_sample_loading_state(evdmusic), 
	FMOD_STUDIO_LOADING_STATE_UNLOADING, "EvDesc Load Sample Data: Unloading");

fmod_studio_system_flush_commands(studio); // update to affect changes now
GMFMS_Assert(fmod_studio_evdesc_get_sample_loading_state(evdmusic), 
	FMOD_STUDIO_LOADING_STATE_UNLOADED, "EvDesc Load Sample Data: Unloaded");

// ----------------------------------------------------------------------------
// EvDesc Is 3D
// ----------------------------------------------------------------------------
GMFMS_Assert(fmod_studio_evdesc_is_3D(evdmusic), true, "EvDesc is 3D: true");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK,
	"EvDesc Is 3D: no errors 1");
GMFMS_Assert(fmod_studio_evdesc_is_3D(evdblip), false, "EvDesc is 3D: false");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK,
	"EvDesc Is 3D: no errors 2");
// ----------------------------------------------------------------------------
// EvDesc Is Oneshot
// ----------------------------------------------------------------------------
// An event is a oneshot if it does not loop indefinitely
GMFMS_Assert(fmod_studio_evdesc_is_oneshot(evdmusic), false, "EvDesc is Oneshot: false");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK,
	"EvDesc Is Oneshot: no errors");
GMFMS_Assert(fmod_studio_evdesc_is_oneshot(evdblip), true, "EvDesc is Oneshot: true");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK,
	"EvDesc Is Oneshot: no errors");
// ----------------------------------------------------------------------------
// EvDesc Is Snapshot
// ----------------------------------------------------------------------------
// Snapshots are mixer presets created in the mixer view of FMOD Studio
// music event is not a snapshot: false
GMFMS_Assert(fmod_studio_evdesc_is_snapshot(evdmusic), false,
	"EvDesc is snapshot: false");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "EvDesc is snapshot: no errors");

// test snapshot is a snapshot: true
GMFMS_Assert(fmod_studio_evdesc_is_snapshot(
	GMFMS_Ptr(fmod_studio_system_get_event(studio, "snapshot:/TestSnapshot"))), 
	true, "EvDesc is snapshot: true");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "EvDesc is snapshot: no errors");
// ----------------------------------------------------------------------------
// EvDesc Is Stream
// ----------------------------------------------------------------------------
// Streaming is set on specific audio assets in the Audio Bin window.
GMFMS_Assert(fmod_studio_evdesc_is_stream(evdmusic), true, 
	"EvDesc is stream: true");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK,
	"EvDesc is stream: no errors");
GMFMS_Assert(fmod_studio_evdesc_is_stream(evdblip), false, 
	"EvDesc is stream: false");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK,
	"EvDesc is stream: no errors");
// ----------------------------------------------------------------------------
// EvDesc Has Cue
// ----------------------------------------------------------------------------
// Cues are placed on the timeline to stop the playhead until activated
// In the FMOD Studio interface it is called a "Sustain Point".
GMFMS_Assert(fmod_studio_evdesc_has_cue(evdmusic), false,
	"EvDesc has cue: false");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "EvDesc has cue: no errors");

GMFMS_Assert(fmod_studio_evdesc_has_cue(
	GMFMS_Ptr(fmod_studio_system_get_event(studio, "event:/TestCueEvent"))), 
	true, "EvDesc has cue: true");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "EvDesc has cue: no errors");

// ----------------------------------------------------------------------------
// EvDesc Get Max Distance (for 3D events)
// ----------------------------------------------------------------------------
// An event only has max distance if it's 3D (returns 0 otherwise. 
// It's considered 3D if you place a spatializer effect on the master bus of 
// that particular event.
GMFMS_Assert(fmod_studio_evdesc_get_max_distance(evdmusic), 20,
	"EvDesc get max distance: 3D event");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "EvDesc get max distance: no errors");
GMFMS_Assert(fmod_studio_evdesc_get_max_distance(evdblip), 0,
	"EvDesc get max distance: 2D event");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "EvDesc get max distance: no errors");

// ----------------------------------------------------------------------------
// EvDesc Get Min Distance (for 3D events)
// ----------------------------------------------------------------------------
// An event only has min distance if it's 3D. It's considered 3D if you
// place a spatializer effect on the master bus of that event.
GMFMS_Assert(fmod_studio_evdesc_get_min_distance(evdmusic), 1,
	"EvDesc get min distance: 3D event");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "EvDesc get min distance: no errors");
GMFMS_Assert(fmod_studio_evdesc_get_min_distance(evdblip), 0,
	"EvDesc get min distance: 2D event");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "EvDesc get min distance: no errors");

// ----------------------------------------------------------------------------
// EvDesc Get Sound Size (for 3D events)
// ----------------------------------------------------------------------------
// An event only has sound size if has a 3D spatializer effect on any buses
// within the event. Sound size is one of the parameters on the spatializer.
GMFMS_Assert(fmod_studio_evdesc_get_sound_size(evdmusic), 2,
	"EvDesc get sound size: 3D event");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "EvDesc get sound size: no errors");
GMFMS_Assert(fmod_studio_evdesc_get_sound_size(evdblip), 0,
	"EvDesc get sound size: 2D event");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "EvDesc get sound size: no errors");
