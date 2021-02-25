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

GMFMS_Assert(fmod_studio_evdesc_is_valid(evdmusic), true, "EvDesc Is Valid 1");
GMFMS_Assert(fmod_studio_evdesc_is_valid(evdblip), true, "EvDesc Is Valid 2");

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
var buf/*: GMFMS_Buffer*/ = GMFMS_GetBuffer();

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

// ----------------------------------------------------------------------------
// EvDesc Get ParamDesc Count
// ----------------------------------------------------------------------------
GMFMS_Assert(fmod_studio_evdesc_get_paramdesc_count(evdmusic), 2,
	"EvDesc Get ParamDesc Count: music event");
GMFMS_Assert(fmod_studio_evdesc_get_paramdesc_count(evdblip), 1,
	"EvDesc Get ParamDesc Count: sfx event");

// ----------------------------------------------------------------------------
// EvDesc Get ParamDesc By Name
// ----------------------------------------------------------------------------
buf = GMFMS_GetBuffer();
fmod_studio_evdesc_get_paramdesc_by_name(evdmusic, "Pitch", buf.getAddress());

var pdesc_pitch/*: GMFMS_ParamDesc*/ = new GMFMS_ParamDesc(buf);
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, 
	"EvDesc Get ParamDesc by name: no errors.");
GMFMS_Assert(pdesc_pitch.name, "Pitch", "EvDesc Get ParamDesc by name: name");
GMFMS_Assert(pdesc_pitch.minimum, 0, "EvDesc Get ParamDesc by name: minimum");
GMFMS_Assert(pdesc_pitch.maximum, 1, "EvDesc Get ParamDesc by name: maximum");
GMFMS_Assert(instanceof(pdesc_pitch.pid), "GMFMS_ParamID", 
	"EvDesc Get ParamDesc by name: pid type");
GMFMS_Assert(pdesc_pitch.defaultvalue, 0.5, 
	"EvDesc Get ParamDesc by name: defaultvalue");
GMFMS_Assert(pdesc_pitch.flags, 0, "EvDesc Get ParamDesc: flags");
delete pdesc_pitch;

// ----------------------------------------------------------------------------
// EvDesc Get ParamDesc By Index
// ----------------------------------------------------------------------------
buf = GMFMS_GetBuffer();
fmod_studio_evdesc_get_paramdesc_by_index(evdmusic, 0, buf.getAddress());

pdesc_pitch = new GMFMS_ParamDesc(buf);
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, 
	"EvDesc Get ParamDesc by index: no errors.");
GMFMS_Assert(pdesc_pitch.name, "RoomSize", "EvDesc Get ParamDesc by index: name");
GMFMS_Assert(pdesc_pitch.minimum, 0, "EvDesc Get ParamDesc by index: minimum");
GMFMS_Assert(pdesc_pitch.maximum, 10, "EvDesc Get ParamDesc by index: maximum");
GMFMS_Assert(instanceof(pdesc_pitch.pid), "GMFMS_ParamID", 
	"EvDesc Get ParamDesc by index: pid type");
GMFMS_Assert(pdesc_pitch.defaultvalue, 0, 
	"EvDesc Get ParamDesc by index: defaultvalue");
GMFMS_Assert(pdesc_pitch.flags, 0, "EvDesc Get ParamDesc by index: flags");
delete pdesc_pitch;

// ----------------------------------------------------------------------------
// EvDesc Get ParamDesc By ID
// ----------------------------------------------------------------------------
buf = GMFMS_GetBuffer();
fmod_studio_evdesc_get_paramdesc_by_name(evdmusic, "Pitch", buf.getAddress());

pdesc_pitch = new GMFMS_ParamDesc(buf);
buf.seekReset();

pdesc_pitch.pid.writeToBuffer(buf);
buf.seekReset();

fmod_studio_evdesc_get_paramdesc_by_id(evdmusic, buf.getAddress());

var pdesc_fromid = new GMFMS_ParamDesc(buf);

GMFMS_Assert(GMFMS_GetError(), FMOD_OK, 
	"EvDesc Get ParamDesc by ID: no errors.");
GMFMS_Assert(pdesc_fromid.name, pdesc_pitch.name, 
	"EvDesc Get ParamDesc by ID: name");
GMFMS_Assert(pdesc_fromid.minimum, pdesc_pitch.minimum, 
	"EvDesc Get ParamDesc by ID: minimum");
GMFMS_Assert(pdesc_fromid.maximum, pdesc_pitch.maximum, 
	"EvDesc Get ParamDesc by ID: maximum");
GMFMS_Assert(instanceof(pdesc_fromid.pid), instanceof(pdesc_pitch.pid), 
	"EvDesc Get ParamDesc by ID: pid type");
GMFMS_Assert(pdesc_fromid.defaultvalue, pdesc_pitch.defaultvalue,
	"EvDesc Get ParamDesc by ID: defaultvalue");
GMFMS_Assert(pdesc_fromid.flags, pdesc_pitch.flags, 
	"EvDesc Get ParamDesc by ID: flags");

delete pdesc_pitch;
delete pdesc_fromid;

// ----------------------------------------------------------------------------
// EvDesc Get User Property
// ----------------------------------------------------------------------------
buf = GMFMS_GetBuffer();
fmod_studio_evdesc_get_user_property(evdblip, "stringprop", buf.getAddress());

var userprop/*: GMFMS_UserProp*/ = new GMFMS_UserProp(buf);

GMFMS_Assert(GMFMS_GetError(), FMOD_OK, 
	"EvDesc Get User Property String: no errors");
GMFMS_Assert(userprop.name, "stringprop", 
	"EvDesc Get User Property String: name");
GMFMS_Assert(userprop.value, "Hello World!", 
	"EvDesc Get User Property String: value");
GMFMS_Assert(userprop.type, FMOD_STUDIO_USER_PROPERTY_TYPE_STRING,
	"EvDesc Get User Property String: type");

buf = GMFMS_GetBuffer();
fmod_studio_evdesc_get_user_property(evdblip, "floatprop", buf.getAddress());

userprop.readFromBuffer(buf);
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, 
	"EvDesc Get User Property Float: no errors");
GMFMS_Assert(userprop.name, "floatprop", 
	"EvDesc Get User Property Float: name");
GMFMS_Assert(userprop.value, 1.234, 
	"EvDesc Get User Property Float: value");
GMFMS_Assert(userprop.type, FMOD_STUDIO_USER_PROPERTY_TYPE_FLOAT,
	"EvDesc Get User Property Float: type");

delete userprop;

// ----------------------------------------------------------------------------
// EvDesc Get User Property By Index
// ----------------------------------------------------------------------------
buf = GMFMS_GetBuffer();
fmod_studio_evdesc_get_user_property_by_index(evdblip, 0, buf.getAddress());

userprop = new GMFMS_UserProp(buf);

GMFMS_Assert(GMFMS_GetError(), FMOD_OK, 
	"EvDesc Get User Property By Index: no errors");
GMFMS_Assert(userprop.name, "boolprop", 
	"EvDesc Get User Property By Index: name");
GMFMS_Assert(userprop.value, 0, 
	"EvDesc Get User Property By Index: value");
GMFMS_Assert(userprop.type, FMOD_STUDIO_USER_PROPERTY_TYPE_FLOAT,
	"EvDesc Get User Property By Index: type");

delete userprop;

// ----------------------------------------------------------------------------
// EvDesc Get User Property Count
// ----------------------------------------------------------------------------
GMFMS_Assert(fmod_studio_evdesc_get_user_property_count(evdmusic), 2, 
	"EvDesc Get User Property Count: props 1");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, 
	"EvDesc Get User Property Count: props 1, no errors");
	
GMFMS_Assert(fmod_studio_evdesc_get_user_property_count(evdblip), 4, 
	"EvDesc Get User Property Count: props 2");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, 
	"EvDesc Get User Property Count: props 2, no errors");
	
// ----------------------------------------------------------------------------
// EvDesc Get ID
// ----------------------------------------------------------------------------
buf = GMFMS_GetBuffer();
fmod_studio_evdesc_get_id(evdmusic, buf.getAddress());
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "EvDesc Get ID: no errors");

var guid/*: GMFMS_GUID*/ = new GMFMS_GUID(buf);

GMFMS_Assert(guid.data1, $4fa3eda1, "EvDesc Get ID: data1");
GMFMS_Assert(guid.data2, $884b, "EvDesc Get ID: data2");
GMFMS_Assert(guid.data3, $4305, "EvDesc Get ID: data3");
GMFMS_Assert(guid.data4[0], $84, "EvDesc Get ID: data4[0]");
GMFMS_Assert(guid.data4[1], $16, "EvDesc Get ID: data4[1]");
GMFMS_Assert(guid.data4[2], $41, "EvDesc Get ID: data4[2]");
GMFMS_Assert(guid.data4[3], $66, "EvDesc Get ID: data4[3]");
GMFMS_Assert(guid.data4[4], $95, "EvDesc Get ID: data4[4]");
GMFMS_Assert(guid.data4[5], $88, "EvDesc Get ID: data4[5]");
GMFMS_Assert(guid.data4[6], $64, "EvDesc Get ID: data4[6]");
GMFMS_Assert(guid.data4[7], $5d, "EvDesc Get ID: data4[7]");

buf = GMFMS_GetBuffer();
fmod_studio_evdesc_get_id(evdblip, buf.getAddress());
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "EvDesc 2 Get ID: no errors");

guid.readFromBuffer(buf);

GMFMS_Assert(guid.data1, $66fd7e65, "EvDesc Get ID 2: data1");
GMFMS_Assert(guid.data2, $d2f3, "EvDesc Get ID 2: data2");
GMFMS_Assert(guid.data3, $4b7b, "EvDesc Get ID 2: data3");
GMFMS_Assert(guid.data4[0], $bc, "EvDesc Get ID 2: data4[0]");
GMFMS_Assert(guid.data4[1], $38, "EvDesc Get ID 2: data4[1]");
GMFMS_Assert(guid.data4[2], $91, "EvDesc Get ID 2: data4[2]");
GMFMS_Assert(guid.data4[3], $3c, "EvDesc Get ID 2: data4[3]");
GMFMS_Assert(guid.data4[4], $0d, "EvDesc Get ID 2: data4[4]");
GMFMS_Assert(guid.data4[5], $b7, "EvDesc Get ID 2: data4[5]");
GMFMS_Assert(guid.data4[6], $10, "EvDesc Get ID 2: data4[6]");
GMFMS_Assert(guid.data4[7], $9c, "EvDesc Get ID 2: data4[7]");

delete guid;

// ----------------------------------------------------------------------------
// EvDesc Get Length
// ----------------------------------------------------------------------------
var length/*: number*/ = fmod_studio_evdesc_get_length(evdmusic)
GMFMS_Assert(length > 60000 && length < 120000, true, "EvDesc Get Length");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "EvDesc Get Length: no errors");

length = fmod_studio_evdesc_get_length(evdblip);
GMFMS_Assert(length > 0 && length < 500, true, "EvDesc Get Length 2");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "EvDesc Get Length 2: no errors");

// ----------------------------------------------------------------------------
// EvDesc Get Path
// ----------------------------------------------------------------------------
GMFMS_Assert(fmod_studio_evdesc_get_path(evdmusic), "event:/Music",
	"EvDesc Get Path: paths match");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "EvDesc Get Path: no errors");

GMFMS_Assert(fmod_studio_evdesc_get_path(evdblip), "event:/UIBlip",
	"EvDesc Get Path 2: paths match");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "EvDesc Get Path 2: no errors");

// ----------------------------------------------------------------------------
// EvDesc Set Callback
// ----------------------------------------------------------------------------
fmod_studio_evdesc_set_callback(evdmusic, 
	FMOD_STUDIO_EVENT_CALLBACK_TIMELINE_BEAT);
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "EvDesc Set Callback: no errors");

var inst = GMFMS_Ptr(fmod_studio_evdesc_create_instance(evdmusic));

fmod_studio_evinst_start(inst);

timer = 0;