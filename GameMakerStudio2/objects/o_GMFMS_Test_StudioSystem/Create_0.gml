// Inherit the parent event
event_inherited();
timer = 0;
checkedParamByName = false;
stopped = false;

perf = new GMFMS_Performance();

/* ========================================================================== *
 * StudioSystem: Banks
 * ========================================================================== */

// ----------------------------------------------------------------------------
// Bank Load File Test
// ----------------------------------------------------------------------------
bank = GMFMS_Ptr(fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.bank",
	FMOD_STUDIO_LOAD_BANK_NONBLOCKING));

// Make sure to load the strings bank before loading any FMOD Studio 
// objects via paths. E.g. get event won't work.
stringsbank = GMFMS_Ptr(fmod_studio_system_load_bank_file(studio,
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

// ----------------------------------------------------------------------------
// Bank Get ID
// ----------------------------------------------------------------------------
var buf = GMFMS_GetBuffer();
fmod_studio_bank_get_id(bank, buf.getAddress());
buf.seekReset();
var bankguid = new GMFMS_GUID(buf);

GMFMS_Assert(bankguid.data1, $d61eb928, "Bank Get ID: data1");
GMFMS_Assert(bankguid.data2, $1d29, "Bank Get ID: data2");
GMFMS_Assert(bankguid.data3, $4449, "Bank Get ID: data3");
GMFMS_Assert(bankguid.data4[0], $b4, "Bank Get ID: data4[0]");
GMFMS_Assert(bankguid.data4[1], $30, "Bank Get ID: data4[1]");
GMFMS_Assert(bankguid.data4[2], $5b, "Bank Get ID: data4[2]");
GMFMS_Assert(bankguid.data4[3], $77, "Bank Get ID: data4[3]");
GMFMS_Assert(bankguid.data4[4], $6d, "Bank Get ID: data4[4]");
GMFMS_Assert(bankguid.data4[5], $56, "Bank Get ID: data4[5]");
GMFMS_Assert(bankguid.data4[6], $13, "Bank Get ID: data4[6]");
GMFMS_Assert(bankguid.data4[7], $47, "Bank Get ID: data4[7]");

// ----------------------------------------------------------------------------
// Bank Unload Test
// ----------------------------------------------------------------------------
fmod_studio_bank_unload(bank);
fmod_studio_system_flush_commands(studio);

GMFMS_Assert(fmod_studio_bank_is_valid(bank), false, "Unload Bank");

bank = GMFMS_Ptr(fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL));

// ----------------------------------------------------------------------------
// Get Bank By ID
// ----------------------------------------------------------------------------
buf = GMFMS_GetBuffer();
bankguid.writeToBuffer(buf);
bank = GMFMS_Ptr(fmod_studio_system_get_bank_by_id(studio, buf.getAddress()));

GMFMS_Assert(fmod_studio_bank_is_valid(bank), true, "Get Bank By ID");

// ----------------------------------------------------------------------------
// Get Bank By Name
// ----------------------------------------------------------------------------
bank = GMFMS_Ptr(fmod_studio_system_get_bank(studio, "bank:/Master"));

GMFMS_Assert(fmod_studio_bank_is_valid(bank), true, "Get Bank By Name");

// ----------------------------------------------------------------------------
// Get Bank Count
// ----------------------------------------------------------------------------
GMFMS_Assert(fmod_studio_system_get_bank_count(studio), 2, "Get Bank Count");

// ----------------------------------------------------------------------------
// Get Bank List
// ----------------------------------------------------------------------------
buf = GMFMS_GetBuffer();
var count = fmod_studio_system_get_bank_list(studio, buf.getSize()/8, 
	buf.getAddress());
	
GMFMS_Assert(GMFMS_Ptr(buf.read(buffer_u64)), stringsbank, "Get Bank List");
GMFMS_Assert(GMFMS_Ptr(buf.read(buffer_u64)), bank, "Get Bank List");
GMFMS_Assert(count, 2, "Get Bank List (Count Matches)");


// ----------------------------------------------------------------------------
// System Unload All (All banks unload)
// ----------------------------------------------------------------------------
fmod_studio_system_unload_all(studio);
fmod_studio_system_flush_commands(studio);

GMFMS_Assert(fmod_studio_system_get_bank_count(studio), 0, "Banks Unload All");

bank = GMFMS_Ptr(fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL));
stringsbank = GMFMS_Ptr(fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.strings.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL));

// ----------------------------------------------------------------------------
// Bank Load Sample Data Test
// ----------------------------------------------------------------------------
fmod_studio_bank_load_sample_data(bank);

// Process sample loading immediately, and stall until loading is finished.
fmod_studio_system_flush_sample_loading(studio);
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "Studio System Flush Sample Loading");

// Check that the samples have successfully loaded.
GMFMS_Assert(fmod_studio_bank_get_sample_loading_state(bank), 
	FMOD_STUDIO_LOADING_STATE_LOADED, "Bank Load Sample Data");

/* ========================================================================== *
 * StudioSystem: Listeners                                                                 
 * ========================================================================== */
 
// ----------------------------------------------------------------------------
// StudioSystem Get/Set Listener Attributes
// functions:
//    fmod_studio_system_set_listener_attributes
//    fmod_studio_system_get_listener_attributes
// ----------------------------------------------------------------------------

 buf = GMFMS_GetBuffer();

 buf.write(buffer_f32, 1);
 buf.write(buffer_f32, 2);
 buf.write(buffer_f32, 3);
 buf.write(buffer_f32, 4);
 buf.write(buffer_f32, 5);
 buf.write(buffer_f32, 6);
 buf.write(buffer_f32, 0);
 buf.write(buffer_f32, 0);
 buf.write(buffer_f32, 1);
 buf.write(buffer_f32, 0);
 buf.write(buffer_f32, 1);
 buf.write(buffer_f32, 0);

buf.seekReset();
fmod_studio_system_set_listener_attributes(studio, 0, buf.getAddress());

var listenerattr = new GMFMS_3DAttr();

fmod_studio_system_get_listener_attributes(studio, 0, buf.getAddress());
listenerattr.readFromBuffer(buf);

GMFMS_Assert(
	listenerattr.position.x == 1 && listenerattr.position.y == 2 && listenerattr.position.z = 3 &&
	listenerattr.velocity.x == 4 && listenerattr.velocity.y == 5 && listenerattr.velocity.z = 6 &&
	listenerattr.forward.x == 0 && listenerattr.forward.y == 0 && listenerattr.forward.z = 1 &&
	listenerattr.up.x == 0 && listenerattr.up.y == 1 && listenerattr.up.z = 0,
	true,
	"Get/Set Studio Listener Attributes");

delete listenerattr;

// ----------------------------------------------------------------------------
// StudioSystem Get/Set Listener Attributes
// functions:
//    fmod_studio_system_set_listener_weight
//    fmod_studio_system_get_listener_weight
// ----------------------------------------------------------------------------
fmod_studio_system_set_listener_weight(studio, 0, .5);
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "StudioSystem Set Listener Weight");

GMFMS_Assert(fmod_studio_system_get_listener_weight(studio, 0), .5,
	"StudioSystem Get Listener Weight");

fmod_studio_system_set_listener_weight(studio, 0, 1);

// ----------------------------------------------------------------------------
// StudioSystem Get/Set Num Listeners
// functions:
//    fmod_studio_system_set_num_listeners
//    fmod_studio_system_get_num_listeners
// ----------------------------------------------------------------------------
fmod_studio_system_set_num_listeners(studio, 3);
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "StudioSystem Set Num Listeners");

GMFMS_Assert(fmod_studio_system_get_num_listeners(studio), 3,
	"StudioSystem Get Num Listeners");

// ----------------------------------------------------------------------------
// StudioSystem Get Bus
// functions:
//    fmod_studio_system_get_bus
//    fmod_studio_bus_is_valid
// ----------------------------------------------------------------------------
masterbus = GMFMS_Ptr((fmod_studio_system_get_bus(studio, "bus:/")));

GMFMS_Assert(fmod_studio_bus_is_valid(masterbus), true, "StudioSystem Get Bus");

// ----------------------------------------------------------------------------
// StudioSystem Get Bus
// functions:
//    fmod_studio_system_get_bus_by_id
// ----------------------------------------------------------------------------
buf.seekReset();

var guid = new GMFMS_GUID();
guid.data1 = $4e99eb8b;
guid.data2 = $3228;
guid.data3 = $4a9a;
guid.data4[0] = $ba;
guid.data4[1] = $a8;
guid.data4[2] = $c7;
guid.data4[3] = $c8;
guid.data4[4] = $c9;
guid.data4[5] = $e3;
guid.data4[6] = $e5;
guid.data4[7] = $c8;
guid.writeToBuffer(buf);

revbus = GMFMS_Ptr(fmod_studio_system_get_bus_by_id(studio, 
	buf.getAddress()));

GMFMS_Assert(fmod_studio_bus_is_valid(revbus), true, 
	"StudioSystem Get Bus by ID");

// ----------------------------------------------------------------------------
// Get Event Description by Path
// functions: 
//    fmod_studio_system_get_event
//    fmod_studio_evdesc_is_valid
// ----------------------------------------------------------------------------
evdesc = GMFMS_Ptr(fmod_studio_system_get_event(studio, "event:/Music"));

GMFMS_Assert(
	fmod_studio_evdesc_is_valid(evdesc) &&
		GMFMS_GetError() == FMOD_OK,
	true, 
	"StudioSystem Get Event Description by Path");

// ----------------------------------------------------------------------------
// Get Event Description by ID
// functions: 
//    fmod_studio_system_get_event_by_id
//    fmod_studio_evdesc_is_valid
// ----------------------------------------------------------------------------
guid.data1 = $66fd7e65;
guid.data2 = $d2f3;
guid.data3 = $4b7b;
guid.data4[0] = $bc;
guid.data4[1] = $38;
guid.data4[2] = $91;
guid.data4[3] = $3c;
guid.data4[4] = $0d;
guid.data4[5] = $b7;
guid.data4[6] = $10;
guid.data4[7] = $9c;
buf.seekReset();
guid.writeToBuffer(buf);

evuiblip = GMFMS_Ptr(fmod_studio_system_get_event_by_id(studio, buf.getAddress()));

GMFMS_Assert(
	fmod_studio_evdesc_is_valid(evdesc) &&
		GMFMS_GetError() == FMOD_OK,
	true, 
	"StudioSystem Get Event Description by ID");

// ----------------------------------------------------------------------------
// Get/Set Global Parameter By Name
// functions: 
//    fmod_studio_system_get_parameter_by_name
//    fmod_studio_system_set_parameter_by_name
// ----------------------------------------------------------------------------
fmod_studio_system_set_parameter_by_name(studio, "Weather", 2.345, true);
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "StudioSystem Set Global Parameter");

GMFMS_Assert(fmod_studio_system_get_parameter_by_name(studio, "Weather"), 2.345,
	"StudioSystem Get Global Paramter");

// ----------------------------------------------------------------------------
// Get/Set Global Parameter By Name Final
// functions: 
//    fmod_studio_system_get_parameter_by_name_final
// ----------------------------------------------------------------------------
fmod_studio_system_set_parameter_by_name(studio, "Weather", 0, false);

// must flush command to activate seekspeed calculation this frame
fmod_studio_system_flush_commands(studio); 

GMFMS_Assert(
	fmod_studio_system_get_parameter_by_name_final(studio, "Weather") > 0, 
	true,
	"StudioSystem Get Global Paramter Final");

// ----------------------------------------------------------------------------
// Get Global Parameter Description
// functions: 
//    fmod_studio_system_get_paramdesc_count
//    fmod_studio_system_get_paramdesc_by_index
// ----------------------------------------------------------------------------
GMFMS_Assert(fmod_studio_system_get_paramdesc_count(studio), 2, 
	"StudioSystem Get Parameter Description Count");
	
buf.seekReset();
fmod_studio_system_get_paramdesc_by_index(studio, 0, buf.getAddress());

var paramdesc = new GMFMS_ParamDesc(buf);

GMFMS_Assert(
	paramdesc.name == "Weather" && paramdesc.maximum == 3 && 
		paramdesc.minimum == 0 && paramdesc.defaultvalue = 0 &&
		paramdesc.flags == FMOD_STUDIO_PARAMETER_GLOBAL &&
		paramdesc.pid.data1 >= 0 && paramdesc.pid.data2 >= 0,
	true, 
	"StudioSystem Get Parameter Description By Index");

buf.seekReset();
fmod_studio_system_get_paramdesc_by_index(studio, 1, buf.getAddress());
var paramdesc2 = new GMFMS_ParamDesc(buf);

paramid_weather = paramdesc.pid;
paramid_time    = paramdesc2.pid;

// ----------------------------------------------------------------------------
// Get/Set Global Parameter By ID
// functions: 
//    fmod_studio_system_set_parameter_by_id
//    fmod_studio_system_get_parameter_by_id
//    fmod_studio_system_get_parameter_by_id_final
// ----------------------------------------------------------------------------
buf.seekReset();
paramid_weather.writeToBuffer(buf);

fmod_studio_system_set_parameter_by_id(studio, buf.getAddress(), 0, true);
fmod_studio_system_set_parameter_by_id(studio, buf.getAddress(), 1.2345, false);

GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "StudioSystem Set Parameter By ID")

GMFMS_Assert(fmod_studio_system_get_parameter_by_id(studio, buf.getAddress()), 
	1.2345, "StudioSystem Get Parameter By ID");
	
fmod_studio_system_flush_commands(studio);

GMFMS_Assert(
	fmod_studio_system_get_parameter_by_id_final(studio, buf.getAddress()) < 1.2345, 
	true, "StudioSystem Get Parameter By ID Final");

// ----------------------------------------------------------------------------
// Set Global Parameters by ids
// functions: 
//    fmod_studio_system_set_parameters_by_ids
// ----------------------------------------------------------------------------
buf.seekReset();
paramid_weather.writeToBuffer(buf);
buf.write(buffer_f32, 0.123);
paramid_time.writeToBuffer(buf);
buf.write(buffer_f32, 10.5);

fmod_studio_system_set_parameters_by_ids(studio, buf.getAddress(), 2, true);

buf.seekReset();
paramid_weather.writeToBuffer(buf);
GMFMS_Assert(
	fmod_studio_system_get_parameter_by_id(studio, buf.getAddress()), 0.123,
	"StudioSystem Set Parameters By IDs 1");

buf.seekReset();
paramid_time.writeToBuffer(buf);
GMFMS_Assert(
	fmod_studio_system_get_parameter_by_id(studio, buf.getAddress()), 10.5,
	"StudioSystem Set Parameters By IDs 2");

// ----------------------------------------------------------------------------
// StudioSystem Get VCA
// functions: 
//    fmod_studio_system_get_vca
// ----------------------------------------------------------------------------
vca = GMFMS_Ptr(fmod_studio_system_get_vca(studio, "vca:/TestVCA"));

GMFMS_Assert(GMFMS_GetError() == FMOD_OK && fmod_studio_vca_is_valid(vca),
	true, "StudioSystem Get VCA");

// ----------------------------------------------------------------------------
// StudioSystem Get VCA by ID
// functions: 
//    fmod_studio_system_get_vca_by_id
// ----------------------------------------------------------------------------
guid.data1 = $498278ec;
guid.data2 = $60ce;
guid.data3 = $42c9;
guid.data4[0] = $ad;
guid.data4[1] = $6d;
guid.data4[2] = $96;
guid.data4[3] = $97;
guid.data4[4] = $f5;
guid.data4[5] = $b9;
guid.data4[6] = $08;
guid.data4[7] = $40;
buf.seekReset();
guid.writeToBuffer(buf);

vca = GMFMS_Ptr(fmod_studio_system_get_vca_by_id(studio, buf.getAddress()));

GMFMS_Assert(GMFMS_GetError() == FMOD_OK && fmod_studio_vca_is_valid(vca),
	true, "StudioSystem Get VCA by ID");

// ----------------------------------------------------------------------------
// StudioSystem Command Capture Start, Stop, Load
// functions: 
//    fmod_studio_system_start_command_capture
//    fmod_studio_system_stop_command_capture
//    fmod_studio_system_load_command_replay
// ----------------------------------------------------------------------------
fmod_studio_system_start_command_capture(studio, 
	working_directory + "commandcapture", FMOD_STUDIO_COMMANDCAPTURE_NORMAL)

GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "StudioSystem Start Command Capture");

fmod_studio_system_stop_command_capture(studio);

GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "StudioSystem Stop Command Capture");

crep = GMFMS_Ptr(fmod_studio_system_load_command_replay(studio,
	working_directory + "commandcapture", FMOD_STUDIO_COMMANDREPLAY_NORMAL));

GMFMS_Assert(fmod_studio_comreplay_is_valid(crep), true, 
	"StudioSystem Load Command Replay");

// ----------------------------------------------------------------------------
// StudioSystem Get Buffer Usage
// functions: 
//    fmod_studio_system_get_buffer_usage
// ----------------------------------------------------------------------------
buf.seekReset();
fmod_studio_system_get_buffer_usage(studio, buf.getAddress());
var buf_usage = new GMFMS_BufUsage(buf);

GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "StudioSystem Get Buffer Usage");

buf_usage.log();

delete buf_usage;
// ----------------------------------------------------------------------------
// StudioSystem Reset Buffer Usage
// functions: 
//    fmod_studio_system_reset_buffer_usage
// ----------------------------------------------------------------------------
fmod_studio_system_reset_buffer_usage(studio);
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "StudioSystem Reset Buffer Usage");

// ----------------------------------------------------------------------------
// StudioSystem Get CPU Usage
// functions: 
//    fmod_studio_system_get_cpu_usage
// ----------------------------------------------------------------------------
buf.seekReset();
fmod_studio_system_get_cpu_usage(studio, buf.getAddress());
var cpu_usage = new GMFMS_CPUUsage(buf);

GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "StudioSystem Get CPU Usage");

cpu_usage.log();

delete cpu_usage;

// ----------------------------------------------------------------------------
// StudioSystem Get Memory Usage
// functions: 
//    fmod_studio_system_get_memory_usage
// ----------------------------------------------------------------------------
buf.seekReset();
fmod_studio_system_get_memory_usage(studio, buf.getAddress());
var mem_usage = new GMFMS_MemUsage(buf);

GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "StudioSystem Get Memory Usage");

mem_usage.log();

delete mem_usage;

// ----------------------------------------------------------------------------
// StudioSystem Set Callback
// functions: 
//    fmod_studio_system_set_callback
// ----------------------------------------------------------------------------
fmod_studio_system_set_callback(studio, FMOD_STUDIO_SYSTEM_CALLBACK_PREUPDATE);
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "StudioSystem Set Callback");

// ----------------------------------------------------------------------------
// StudioSystem Get Core System
// functions: 
//    fmod_studio_system_get_core_system
// ----------------------------------------------------------------------------
core = GMFMS_Ptr(fmod_studio_system_get_core_system(studio));
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "StudioSystem Get Core System");

// ----------------------------------------------------------------------------
// StudioSystem Lookup ID/Path
// functions: 
//    fmod_studio_system_lookup_id
//    fmod_studio_system_lookup_path
// ----------------------------------------------------------------------------
buf.seekReset();
fmod_studio_system_lookup_id(studio, "event:/Music", buf.getAddress());
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "StudioSystem Lookup ID: no errors");
guid = new GMFMS_GUID(buf);

buf.seekReset();
guid.writeToBuffer(buf);
var evmusic = GMFMS_Ptr(
	fmod_studio_system_get_event_by_id(studio, buf.getAddress()));

GMFMS_Assert(fmod_studio_evdesc_is_valid(evmusic), true,
	"StudioSystem Lookup ID: valid id");

GMFMS_Assert(fmod_studio_system_lookup_path(studio, buf.getAddress()),
	"event:/Music", "StudioSystem Lookup Path: path matches");
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, 
	"StudioSystem Lookup Path: no errors");

//// Move these tests elsewhere
//// ----------------------------------------------------------------------------
//// Create Event Instance from Event Description
//// functions:
////    fmod_studio_evdesc_create_instance
////    fmod_studio_evinst_is_valid
//// ----------------------------------------------------------------------------
//evinst = GMFMS_Ptr(fmod_studio_evdesc_create_instance(evdesc));

//GMFMS_Assert(fmod_studio_evinst_is_valid(evinst), true,
//	"Create Event Instance from Description");

//// ----------------------------------------------------------------------------
//// Start Event Instance
//// ----------------------------------------------------------------------------
//fmod_studio_evinst_start(evinst);

//fmod_studio_system_flush_commands(studio);

//var playbackstate;
//do {
//	playbackstate = fmod_studio_evinst_get_playback_state(evinst);
//} until (playbackstate == FMOD_STUDIO_PLAYBACK_PLAYING);

//show_debug_message("[Start Event Instance] PASSED.");

//// ============================================================================
//// Get ParamDescription By Name
//// ============================================================================
//buf = GMFMS_GetBuffer();
//fmod_studio_evdesc_get_paramdesc_by_name(evdesc, "Pitch", buf.getAddress());
//paramdesc_pitch = new GMFMS_ParamDesc(buf);

//// Check that each field is as expected.
//GMFMS_Assert(paramdesc_pitch.name, "Pitch", "ParamDesc Get Name");
//GMFMS_Assert(paramdesc_pitch.minimum, 0, "ParamDesc Get Minimum");
//GMFMS_Assert(paramdesc_pitch.maximum, 1, "ParamDesc Get Maximum");
//GMFMS_Assert(paramdesc_pitch.defaultvalue, 0.5, "ParamDesc Get Default");
//GMFMS_Assert(paramdesc_pitch.flags, 0, "ParamDesc Get Flags");

//buf.seekReset();

//// ============================================================================
//// Get ParamDescription By ID
//// ============================================================================
//paramdesc_pitch.pid.writeToBuffer(buf);
//fmod_studio_evdesc_get_paramdesc_by_id(evdesc, buf.getAddress());
//buf.seekReset();

//var paramdesc_pitch_by_id = new GMFMS_ParamDesc(buf);

//// Check that each field is as expected.
//GMFMS_Assert(paramdesc_pitch_by_id.name, "Pitch", "ParamDesc by ID Get Name");
//GMFMS_Assert(paramdesc_pitch_by_id.minimum, 0, "ParamDesc by ID Get Minimum");
//GMFMS_Assert(paramdesc_pitch_by_id.maximum, 1, "ParamDesc by ID Get Maximum");
//GMFMS_Assert(paramdesc_pitch_by_id.defaultvalue, 0.5, "ParamDesc by ID Get Default");
//GMFMS_Assert(paramdesc_pitch_by_id.flags, 0, "ParamDesc by ID Get Flags");

//delete paramdesc_pitch_by_id;
