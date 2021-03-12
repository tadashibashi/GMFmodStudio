event_inherited();

studio.loadBankFile("soundbanks/Desktop/Master_ENG.bank",
    FMOD_STUDIO_LOAD_BANK_NORMAL);
GMFMOD_Check("Loading master bank file");
studio.loadBankFile("soundbanks/Desktop/Master_ENG.strings.bank",
    FMOD_STUDIO_LOAD_BANK_NORMAL);
GMFMOD_Check("Loading strings bank file");

edmusic = studio.getEvent("event:/Music"); /// @is {GMFMOD_Studio_EventDescription}
GMFMOD_Check("Getting music event");
edblip = studio.getEvent("event:/UIBlip"); /// @is {GMFMOD_Studio_EventDescription}
GMFMOD_Check("Getting blip event");

GMFMOD_Assert(edmusic.isValid(), true, "Retrieved event is valid: music");
GMFMOD_Assert(edblip.isValid(), true, "Retrieved event is valid: blip");

instmusic = edmusic.createInstance(); /// @is {GMFMOD_Studio_EventInstance}
GMFMOD_Check("Creating music instance");
GMFMOD_Assert(instmusic.isValid(), true, "Music instance is valid.");

instblip = edblip.createInstance();  /// @is {GMFMOD_Studio_EventInstance}
GMFMOD_Check("Creating music instance");
GMFMOD_Assert(instblip.isValid(), true, "Music instance is valid.");


// ----------------------------------------------------------------------------
// EvInst Start/Stop
// ----------------------------------------------------------------------------
// Start
instmusic.start();
GMFMOD_Check("Starting event instance");
GMFMOD_Assert(instmusic.getPlaybackState(), FMOD_STUDIO_PLAYBACK_STARTING,
    "Music event instance: starting");
GMFMOD_Check("Getting playback state");

studio.flushCommands();
GMFMOD_Check("Flushing commands");

GMFMOD_Assert(instmusic.getPlaybackState(), FMOD_STUDIO_PLAYBACK_PLAYING,
    "Music event instance: playing");
GMFMOD_Check("Getting playback state");

// Stop
instmusic.stop(FMOD_STUDIO_STOP_IMMEDIATE);
GMFMOD_Check("Stopping event instance");

GMFMOD_Assert(instmusic.getPlaybackState(), FMOD_STUDIO_PLAYBACK_STOPPING,
    "Music event instance: stopping");
GMFMOD_Check("Getting playback state");

studio.flushCommands();
GMFMOD_Check("Flushing commands");

GMFMOD_Assert(instmusic.getPlaybackState(), FMOD_STUDIO_PLAYBACK_STOPPED,
    "Music event instance: stopped");
GMFMOD_Check("Getting playback state");


// ----------------------------------------------------------------------------
// EvInst Set/Get Paused
// ----------------------------------------------------------------------------
instmusic.setPaused(true);
GMFMOD_Check("Setting paused");

GMFMOD_Assert(instmusic.getPaused(), true, "Music instance is paused");

instmusic.setPaused(false);
GMFMOD_Check("Setting unpaused");

GMFMOD_Assert(instmusic.getPaused(), false, "Music instance is unpaused");


// ----------------------------------------------------------------------------
// EvInst Trigger Cue
// ----------------------------------------------------------------------------
var evdcue/*: GMFMOD_Studio_EventDescription*/ = studio.getEvent("event:/TestCueEvent");
var evicue/*: GMFMOD_Studio_EventInstance*/    = evdcue.createInstance();

evicue.triggerCue();
GMFMOD_Check("Triggering cue");

instblip.triggerCue();
GMFMOD_Assert(GMFMOD_GetError() != FMOD_OK, true, 
    "Non-cue track cue-triggered causes error");

evicue.release();
GMFMOD_Check("Releasing cue instance");

studio.flushCommands();
GMFMOD_Check("Flushing commands");

GMFMOD_Assert(evicue.isValid(), false, "Cue instance is released");

delete evdcue;
delete evicue;

// ----------------------------------------------------------------------------
// EvInst Set/Get Pitch
// ----------------------------------------------------------------------------
instmusic.setPitch(2.34);
GMFMOD_Check("Setting pitch");

GMFMOD_Assert(instmusic.getPitch(), 2.34, "Pitch matches set value");
GMFMOD_Check("Getting pitch");


// ----------------------------------------------------------------------------
// EvInst Set/Get Property
// ----------------------------------------------------------------------------
instmusic.setProperty(FMOD_STUDIO_EVENT_PROPERTY_CHANNELPRIORITY, 5);
GMFMOD_Check("Setting property");

GMFMOD_Assert(instmusic.getProperty(FMOD_STUDIO_EVENT_PROPERTY_CHANNELPRIORITY),
    5, "Channel priority value matches");
GMFMOD_Check("Getting instance property");

// Set invalid param
instmusic.setProperty(FMOD_STUDIO_EVENT_PROPERTY_CHANNELPRIORITY, -5.2);
GMFMOD_Assert(GMFMOD_GetError(), FMOD_ERR_INVALID_PARAM,
    "Set property: invalid param value passed");
GMFMOD_Assert(instmusic.getProperty(FMOD_STUDIO_EVENT_PROPERTY_CHANNELPRIORITY),
    5, "Setting an invalid property does not alter its value");
GMFMOD_Check("Get property");


// ----------------------------------------------------------------------------
// EvInst Set/Get Timeline position
// ----------------------------------------------------------------------------
// Set timeline position in milliseconds. Receives ints, will be truncated.
instmusic.setTimelinePosition(0);
instmusic.setTimelinePosition(4.1234);
GMFMOD_Check("Setting timeline position");

GMFMOD_Assert(instmusic.getTimelinePosition(), 0, 
    "Timeline position needs update to go into effect");

studio.flushCommands();
GMFMOD_Check("Flushing commands");

GMFMOD_Assert(instmusic.getTimelinePosition(), 4, 
    "Timeline position value matches");

// ----------------------------------------------------------------------------
// EvInst Set/Get Volume
// ----------------------------------------------------------------------------
instmusic.setVolume(.5);
GMFMOD_Check("Setting instance volume to .5");
GMFMOD_Assert(instmusic.getVolume(), .5, "Volume matches set value");
GMFMOD_Check("Getting instance volume");

instmusic.setVolume(1);
GMFMOD_Check("Setting instance volume to 1");
GMFMOD_Assert(instmusic.getVolume(true), 1, 
    "Volume matches set value (finalvalue)");
GMFMOD_Check("Getting instance volume");

// ----------------------------------------------------------------------------
// EvInst Is Virtual
// ----------------------------------------------------------------------------
// The music event is set where only one instance can play at a time before
// becoming virtual. The second instance to play will steal the channel of the
// currently playing instance and force it to become virtual as demonstrated.
//
GMFMOD_Assert(instmusic.isVirtual(), false, "Music instance is not virtual");
GMFMOD_Check("Checking if instance if virtual");

var virttest_inst = edmusic.createInstance();
GMFMOD_Check("Creating virtual test instance");
GMFMOD_Assert(virttest_inst.isValid(), true, "Virtual test instance is valid");

instmusic.start();
GMFMOD_Check("Starting music instance");
virttest_inst.start();
GMFMOD_Check("Starting music instance 2");
GMFMOD_Assert(instmusic.getPlaybackState(), FMOD_STUDIO_PLAYBACK_STARTING,
    "Music instance is starting");
GMFMOD_Assert(virttest_inst.getPlaybackState(), FMOD_STUDIO_PLAYBACK_STARTING,
    "Music instance 2 is starting");

studio.flushCommands();
GMFMOD_Check("Flushing commands");

GMFMOD_Assert(instmusic.getPlaybackSTate(), FMOD_STUDIO_PLAYBACK_PLAYING,
    "Music instance is playing");
GMFMOD_Assert(virttest_inst.getPlaybackSTate(), FMOD_STUDIO_PLAYBACK_PLAYING,
    "Music instance 2 is playing");

GMFMOD_Assert(instmusic.isVirtual(), true, 
    "First instance became virtual");
GMFMOD_Assert(virttest_inst.isVirtual(), false, 
    "Second instance steals first's stop and is real");

instmusic.stop(FMOD_STUDIO_STOP_IMMEDIATE);
GMFMOD_Check("Stopping first instance");
virttest_inst.stop(FMOD_STUDIO_STOP_IMMEDIATE);
GMFMOD_Check("Stopping second instance");
virttest_inst.release();
GMFMOD_Check("Releasing second instance");

studio.flushCommands();
GMFMOD_Check("Flushing commands");


// ----------------------------------------------------------------------------
// EvInst Set/Get 3D Attributes
// ----------------------------------------------------------------------------
var attr/*: GMFMOD_3D_ATTRIBUTES*/ = new GMFMOD_3D_ATTRIBUTES();
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

instmusic.set3DAttributes(attr);
GMFMOD_Check("Setting 3D Attributes");

// Passed by ref
var getattr = new GMFMOD_3D_ATTRIBUTES();
instmusic.get3DAttributes(getattr);
GMFMOD_Check("Getting 3D Attributes");

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

// Returned by value
var getattr = instmusic.get3DAttributes();
GMFMOD_Check("Getting 3D Attributes");

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

delete attr;
delete getattr;


// ----------------------------------------------------------------------------
// EvInst Set/Get Listener Mask
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// EvInst Set/Get Parameter
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// EvInst Get Channel Group (NOT SUPPORTED)
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// EvInst Set/Get Core Reverb Level
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// EvInst Get CPU Usage
// FMOD_INIT_PROFILE_ENABLE with System::init is required to call these functions!
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// EvInst Get Memory Usage
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// EvInst Get Description
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// EvInst Release
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// EvInst Set Callback
// ----------------------------------------------------------------------------
