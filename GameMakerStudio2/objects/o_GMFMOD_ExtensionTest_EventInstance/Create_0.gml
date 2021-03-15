event_inherited();

fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL);
	
fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.strings.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL);


evdmusic = GMFMOD_Ptr(fmod_studio_system_get_event(studio, "event:/Music"));
evdblip = GMFMOD_Ptr(fmod_studio_system_get_event(studio, "event:/UIBlip"));

evimusic = GMFMOD_Ptr(fmod_studio_evdesc_create_instance(evdmusic));
eviblip = GMFMOD_Ptr(fmod_studio_evdesc_create_instance(evdblip));

GMFMOD_Assert(fmod_studio_evinst_is_valid(evimusic), true, "EvInst is valid 1");
GMFMOD_Assert(fmod_studio_evinst_is_valid(eviblip), true, "EvInst is valid 2");

// ----------------------------------------------------------------------------
// EvInst Start/Stop
// ----------------------------------------------------------------------------
fmod_studio_evinst_start(evimusic);

GMFMOD_Assert(GMFMOD_GetError(), FMOD_OK, "EvInst Start: no errors");
GMFMOD_Assert(fmod_studio_evinst_get_playback_state(evimusic), 
	FMOD_STUDIO_PLAYBACK_STARTING, "EvInst Start: starting");

fmod_studio_system_flush_commands(studio);
GMFMOD_Assert(fmod_studio_evinst_get_playback_state(evimusic), 
	FMOD_STUDIO_PLAYBACK_PLAYING, "EvInst Start: playing");

fmod_studio_evinst_stop(evimusic, FMOD_STUDIO_STOP_IMMEDIATE);

GMFMOD_Assert(GMFMOD_GetError(), FMOD_OK, "EvInst Stop: no errors");
GMFMOD_Assert(fmod_studio_evinst_get_playback_state(evimusic), 
	FMOD_STUDIO_PLAYBACK_STOPPING, "EvInst Stop: stopping");

fmod_studio_system_flush_commands(studio);
GMFMOD_Assert(fmod_studio_evinst_get_playback_state(evimusic), 
	FMOD_STUDIO_PLAYBACK_STOPPED, "EvInst Stop: stopped");

// ----------------------------------------------------------------------------
// EvInst Set/Get Paused
// ----------------------------------------------------------------------------
fmod_studio_evinst_set_paused(evimusic, true);
GMFMOD_Check("EvInst Set Paused: true");

GMFMOD_Assert(fmod_studio_evinst_get_paused(evimusic), true,
	"EvInst Get Paused: true");

fmod_studio_evinst_set_paused(evimusic, false);
GMFMOD_Check("EvInst Set Paused: false");
GMFMOD_Assert(fmod_studio_evinst_get_paused(evimusic), false,
	"EvInst Get Paused: false");

// ----------------------------------------------------------------------------
// EvInst Trigger Cue
// ----------------------------------------------------------------------------
var evdcue = GMFMOD_Ptr(fmod_studio_system_get_event(studio, 
	"event:/TestCueEvent"));
var evicue = GMFMOD_Ptr(fmod_studio_evdesc_create_instance(evdcue));
fmod_studio_evinst_trigger_cue(evicue);
GMFMOD_Check("EvInst Trigger Cue");

fmod_studio_evinst_trigger_cue(eviblip);
GMFMOD_Assert(GMFMOD_GetError() != FMOD_OK, true,
	"EvInst Trigger Cue: non-cue event causes error");
	
fmod_studio_evinst_release(evicue);
fmod_studio_system_flush_commands(studio);

delete evdcue;
delete evicue;

// ----------------------------------------------------------------------------
// EvInst Set/Get Pitch
// ----------------------------------------------------------------------------
fmod_studio_evinst_set_pitch(evimusic, 1);
fmod_studio_evinst_set_pitch(evimusic, 2.34);
GMFMOD_Check("EvInst set pitch: no errors");

GMFMOD_Assert(fmod_studio_evinst_get_pitch(evimusic), 2.34, 
	"EvInst get pitch: matches set pitch value");
GMFMOD_Check("EvInst get pitch: no errors");

 // Must flush commands to see changes in pitch_final function
fmod_studio_system_flush_commands(studio);
var finalpitch = fmod_studio_evinst_get_pitch_final(evimusic);
GMFMOD_Check("EvInst get pitch final: no errors");
GMFMOD_Assert(finalpitch , 2.34, "EvInst get pitch final");

// ----------------------------------------------------------------------------
// EvInst Set/Get Property
// ----------------------------------------------------------------------------
fmod_studio_evinst_set_property(evimusic, 
	FMOD_STUDIO_EVENT_PROPERTY_CHANNELPRIORITY, 5);
GMFMOD_Check("EvInst set property: no errors");
GMFMOD_Assert(fmod_studio_evinst_get_property(evimusic, 
	FMOD_STUDIO_EVENT_PROPERTY_CHANNELPRIORITY), 
	5, 
	"EvInst get property: matches set value");
GMFMOD_Check("EvInst get property: no errors");

fmod_studio_evinst_set_property(evimusic, 
	FMOD_STUDIO_EVENT_PROPERTY_CHANNELPRIORITY, -5.2);
GMFMOD_Assert(GMFMOD_GetError(), FMOD_ERR_INVALID_PARAM,
	"EvInst set property: invalid param value passed");
GMFMOD_Assert(fmod_studio_evinst_get_property(evimusic, 
	FMOD_STUDIO_EVENT_PROPERTY_CHANNELPRIORITY), 
	5, 
	"EvInst get property: value not altered by invalid param value");
GMFMOD_Check("EvInst get property: no errors");

// ----------------------------------------------------------------------------
// EvInst Set/Get Timeline position
// ----------------------------------------------------------------------------
fmod_studio_evinst_set_timeline_position(evimusic, 4.1234);
GMFMOD_Check("EvInst set timeline position: no errors");
GMFMOD_Assert(fmod_studio_evinst_get_timeline_position(evimusic),  
	0, "EvInst get timeline position, no updates yet");
GMFMOD_Check("EvInst get timeline position: no errors");

fmod_studio_system_flush_commands(studio);

GMFMOD_Assert(fmod_studio_evinst_get_timeline_position(evimusic),  
	4, "EvInst get timeline position: values match after update. (Truncated int)");

// ----------------------------------------------------------------------------
// EvInst Set/Get Volume
// ----------------------------------------------------------------------------
fmod_studio_evinst_set_volume(evimusic, .5);
GMFMOD_Check("EvInst Set Volume: no errors");
GMFMOD_Assert(fmod_studio_evinst_get_volume(evimusic), .5,
	"EvInst Get Volume matches");

fmod_studio_system_flush_commands(studio);
GMFMOD_Assert(fmod_studio_evinst_get_volume_final(evimusic), .5,
	"EvInst Get Volume Final: test 1");
GMFMOD_Check("EvInst get volume final: no errors");

fmod_studio_evinst_set_volume(evimusic, 1);

fmod_studio_system_flush_commands(studio);
GMFMOD_Assert(fmod_studio_evinst_get_volume_final(evimusic), 1,
	"EvInst Get Volume Final: test 2");
	

// ----------------------------------------------------------------------------
// EvInst Is Virtual
// ----------------------------------------------------------------------------

// Is Virtual Error Check
GMFMOD_Assert(fmod_studio_evinst_is_virtual(evimusic), false, 
	"EvInst Is Virtual: false");
GMFMOD_Check("EvInst Is Virtual: no errors");

// Music Instance has a 1-voice limitation with stealing set to "virtualize"
// Any additional instances started will steal the current one by virtualizing it.
var virttest_inst = GMFMOD_Ptr(fmod_studio_evdesc_create_instance(evdmusic));
fmod_studio_evinst_start(virttest_inst);
fmod_studio_evinst_start(evimusic);
fmod_studio_system_flush_commands(studio);
GMFMOD_Assert(fmod_studio_evinst_is_virtual(evimusic), false, 
	"EvInst Is Virtual: false");
GMFMOD_Assert(fmod_studio_evinst_is_virtual(virttest_inst), true, 
	"EvInst Is Virtual: true");

fmod_studio_evinst_stop(evimusic, FMOD_STUDIO_STOP_IMMEDIATE);
fmod_studio_evinst_stop(virttest_inst, FMOD_STUDIO_STOP_IMMEDIATE);
fmod_studio_evinst_release(virttest_inst);

fmod_studio_system_flush_commands(studio);


// ----------------------------------------------------------------------------
// EvInst Set/Get 3D Attributes
// ----------------------------------------------------------------------------
var buf = GMFMOD_GetBuffer();
var attr = new GMFMOD_3D_ATTRIBUTES();
attr.position.x = 1;
attr.position.y = 2;
attr.position.z = 3;
attr.velocity.x = 4;
attr.velocity.y = 5;
attr.velocity.z = 6;
attr.forward.x  = 0;
attr.forward.y  = 0;
attr.forward.z  = 1;
attr.up.x       = 0;
attr.up.y       = 1;
attr.up.z       = 0;
attr.writeToBuffer(buf);
fmod_studio_evinst_set_3D_attributes(evimusic, buf.getAddress());
GMFMOD_Check("EvInst Set3DAttributes: no errors");

buf.seekReset();
fmod_studio_evinst_get_3D_attributes(evimusic, buf.getAddress());
GMFMOD_Check("EvInst Get3DAttributes: no errors");

var getattr = new GMFMOD_3D_ATTRIBUTES(buf);
GMFMOD_Assert(getattr.position.x, attr.position.x, "EvInst Get3DAttr: position.x");
GMFMOD_Assert(getattr.position.y, attr.position.y, "EvInst Get3DAttr: position.y");
GMFMOD_Assert(getattr.position.z, attr.position.z, "EvInst Get3DAttr: position.z");
GMFMOD_Assert(getattr.velocity.x, attr.velocity.x, "EvInst Get3DAttr: velocity.x");
GMFMOD_Assert(getattr.velocity.y, attr.velocity.y, "EvInst Get3DAttr: velocity.y");
GMFMOD_Assert(getattr.velocity.z, attr.velocity.z, "EvInst Get3DAttr: velocity.z");
GMFMOD_Assert(getattr.forward.x, attr.forward.x, "EvInst Get3DAttr: forward.x");
GMFMOD_Assert(getattr.forward.y, attr.forward.y, "EvInst Get3DAttr: forward.y");
GMFMOD_Assert(getattr.forward.z, attr.forward.z, "EvInst Get3DAttr: forward.z");
GMFMOD_Assert(getattr.up.x, attr.up.x, "EvInst Get3DAttr: up.x");
GMFMOD_Assert(getattr.up.y, attr.up.y, "EvInst Get3DAttr: up.y");
GMFMOD_Assert(getattr.up.z, attr.up.z, "EvInst Get3DAttr: up.z");

delete getattr;
delete attr;

// ----------------------------------------------------------------------------
// EvInst Set/Get Listener Mask
// ----------------------------------------------------------------------------
/*
To create the mask you must perform bitwise OR and shift operations, the basic 
form is 1 << listener_index ORd together with other required listener indices.
For example to create a mask for listener index 0 and 2 the calculation would 
be mask = (1 << 0) | (1 << 2), to include all listeners use the default mask of 
0xFFFFFFFF.
*/
var mask = (1 << 0) | (1 << 2) | (1 << 3);

fmod_studio_evinst_set_listener_mask(evimusic, mask);
GMFMOD_Check("EvInst Set Listener Mask: no errors");

GMFMOD_Assert(fmod_studio_evinst_get_listener_mask(evimusic), mask,
	"EvInst Get Listener Mask matches");
GMFMOD_Check("EvInst Get Listener Mask: no errors");

// ----------------------------------------------------------------------------
// EvInst Set/Get Parameter
// ----------------------------------------------------------------------------
// by Name
fmod_studio_evinst_set_parameter_by_name(evimusic, "RoomSize", 0, true);
fmod_studio_evinst_set_parameter_by_name(evimusic, "RoomSize", .5, true);
GMFMOD_Check("EvInst Set Parameter by Name: no errors");

GMFMOD_Assert(fmod_studio_evinst_get_parameter_by_name(evimusic, "RoomSize"), .5,
	"EvInst Get Parameter by Name");

GMFMOD_Assert(fmod_studio_evinst_get_parameter_by_name_final(evimusic, "RoomSize"),
	0, "EvInst Get Parameter by Name final: command not flushed");
GMFMOD_Check("EvInst Set Parameter by Name Final: no errors");

fmod_studio_system_flush_commands(studio);
GMFMOD_Check("Flushing commands");

GMFMOD_Assert(fmod_studio_evinst_get_parameter_by_name_final(evimusic, 
	"RoomSize") > 0, true, 
	"EvInst Get Parameter by Name final: command was flushed");

fmod_studio_evinst_set_parameter_by_name(evimusic, "RoomSize", 0, true);
fmod_studio_system_flush_commands(studio);

// by ID
buf = GMFMOD_GetBuffer();
fmod_studio_evdesc_get_paramdesc_by_name(evdmusic, "RoomSize", buf.getAddress());
GMFMOD_Check("EvDesc Get Param Desc By Name: no errors");

var pdesc/*: GMFMOD_STUDIO_PARAMETER_DESCRIPTION*/ = 
	new GMFMOD_STUDIO_PARAMETER_DESCRIPTION(buf);
buf.seekReset();
pdesc.pid.writeToBuffer(buf);

fmod_studio_evinst_set_parameter_by_id(evimusic, buf.getAddress(), .123, true);
GMFMOD_Check("EvInst Set Parameter by ID: no errors");

GMFMOD_Assert(
	fmod_studio_evinst_get_parameter_by_id(evimusic, buf.getAddress()), 
	.123, 
	"EvInst Get Parameter by ID matches");
GMFMOD_Check("EvInst Get Paramter by ID: no errors");

// final
GMFMOD_Assert(
	fmod_studio_evinst_get_parameter_by_id_final(evimusic, buf.getAddress()),
	0,
	"EvInst Get Parameter by ID final: command not flushed");

fmod_studio_system_flush_commands(studio);

GMFMOD_Assert(
	fmod_studio_evinst_get_parameter_by_id_final(evimusic, buf.getAddress()) > 0,
	true,
	"EvInst Get Parameter by ID final: command was flushed");
	
fmod_studio_evinst_set_parameter_by_id(evimusic, buf.getAddress(), 0, true);


// set params by IDs
buf = GMFMOD_GetBuffer();
fmod_studio_evdesc_get_paramdesc_by_name(evdmusic, "Pitch", buf.getAddress());
GMFMOD_Check("EvDesc Get Param Desc By Name: no errors");

var pdesc2/*: GMFMOD_STUDIO_PARAMETER_DESCRIPTION*/ = 
	new GMFMOD_STUDIO_PARAMETER_DESCRIPTION(buf);

buf.seekReset();
pdesc.pid.writeToBuffer(buf);
buf.write(buffer_f32, .789);
pdesc2.pid.writeToBuffer(buf);
buf.write(buffer_f32, .012);

fmod_studio_evinst_set_parameters_by_ids(evimusic, buf.getAddress(), 2, false);
GMFMOD_Check("EvInst Set Params by IDs: no errors");

buf.seekReset();
pdesc.pid.writeToBuffer(buf);
GMFMOD_Assert(fmod_studio_evinst_get_parameter_by_id(evimusic, buf.getAddress()),
	.789, "EvInst Set Params by IDs, first value matches");

buf.seekReset();
pdesc2.pid.writeToBuffer(buf);
GMFMOD_Assert(fmod_studio_evinst_get_parameter_by_id(evimusic, buf.getAddress()),
	.012, "EvInst Set Params by IDs, second value matches");

// ----------------------------------------------------------------------------
// EvInst Get Channel Group
// ----------------------------------------------------------------------------
GMFMOD_Assert(fmod_studio_evinst_get_channel_group(evimusic) != 0, true,
	"EvInst Get Channel Group: valid channel group retrieved");
GMFMOD_Check("EvInst Get Channel Group: no errors");

// ----------------------------------------------------------------------------
// EvInst Set/Get Core Reverb Level
// ----------------------------------------------------------------------------
fmod_studio_evinst_set_reverb_level(evimusic, 0, .7654);
GMFMOD_Check("EvInst Set Reverb Level: no errors");

GMFMOD_Assert(fmod_studio_evinst_get_reverb_level(evimusic, 0), .7654, 
	"EvInst Get Reverb Level matches");
GMFMOD_Check("EvInst Get Reverb Level: no errors");

// ----------------------------------------------------------------------------
// EvInst Get CPU Usage
// FMOD_INIT_PROFILE_ENABLE with System::init is required to call these functions!
// ----------------------------------------------------------------------------
fmod_studio_evinst_get_cpu_usage_exclusive(evimusic);
GMFMOD_Check("EvInst Get CPU Usage Exclusive: no errors");

fmod_studio_evinst_get_cpu_usage_inclusive(evimusic);
GMFMOD_Check("EvInst Get CPU Usage Inclusive: no errors");

// ----------------------------------------------------------------------------
// EvInst Get Memory Usage
// ----------------------------------------------------------------------------
buf = GMFMOD_GetBuffer();
fmod_studio_evinst_get_memory_usage(evimusic, buf.getAddress());
GMFMOD_Check("EvInst Get Memory Usage: no errors");

var memusage = new GMFMOD_STUDIO_MEMORY_USAGE(buf);
GMFMOD_Assert(memusage.exclusive != -1, true, 
	"EvInst Get Memory Usage: exclusive");
GMFMOD_Assert(memusage.inclusive != -1, true, 
	"EvInst Get Memory Usage: inclusive");
GMFMOD_Assert(memusage.sampledata != -1, true, 
	"EvInst Get Memory Usage: sampledata");


// ----------------------------------------------------------------------------
// EvInst Get Description
// ----------------------------------------------------------------------------
GMFMOD_Assert(GMFMOD_Ptr(fmod_studio_evinst_get_description(evimusic)), evdmusic,
	"EvInst Get Description: matches");
GMFMOD_Check("EvInst Get Description: no errors");

timer = 0;

// ----------------------------------------------------------------------------
// EvInst Release
// ----------------------------------------------------------------------------
fmod_studio_evinst_release(evimusic);
GMFMOD_Check("EvInst Release: no errors");

fmod_studio_system_flush_commands(studio);

GMFMOD_Assert(fmod_studio_evinst_is_valid(evimusic), false, 
	"EvInst Release succeeded");

evimusic = GMFMOD_Ptr(fmod_studio_evdesc_create_instance(evdmusic));

///////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
// EvInst Set Callback
// ----------------------------------------------------------------------------
fmod_studio_evinst_set_callback(evimusic, 
	FMOD_STUDIO_EVENT_CALLBACK_TIMELINE_BEAT);
GMFMOD_Check("EvInst Set Callback: no errors");
// Testing Music callback by playing the instance
fmod_studio_evinst_start(evimusic);
