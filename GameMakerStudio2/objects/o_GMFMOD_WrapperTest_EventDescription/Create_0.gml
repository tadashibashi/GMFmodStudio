// Inherit the parent event
event_inherited();

timer = 0;

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

// ===== Create Instance =========
var eimusic = edmusic.createInstance();
GMFMOD_Check("Creating instance");
var eimusicByRef = new GMFMOD_Studio_EventInstance();
edmusic.createInstance(eimusicByRef);
GMFMOD_Check("Creating instance, assign by ref");

GMFMOD_Assert(eimusic.isValid(), true, "Created music instance is valid");
GMFMOD_Assert(eimusicByRef.isValid(), true, "Created music instance is valid");

// Note: Please make sure to stop (if playing) and release instances before deleting
eimusic.release();
GMFMOD_Check("Releasing music instance");
eimusicByRef.release();
GMFMOD_Check("Releasing music instance");
studio.flushCommands(); // commands must be flushed to process now
GMFMOD_Check("Flushing commands");
delete eimusic;
delete eimusicByRef;

// ====== Get Instance Count/ Release all instances ======
var eimusic = edmusic.createInstance();
GMFMOD_Check("Creating music instance");
GMFMOD_Assert(edmusic.getInstanceCount(), 1, "Get Instance Count matches");
GMFMOD_Check("Getting instance count");
edmusic.createInstance();
GMFMOD_Assert(edmusic.getInstanceCount(), 2, "Get Instance Count matches");
GMFMOD_Check("Getting instance count");

eimusic.release();
GMFMOD_Check("Releasing music instance");

studio.flushCommands(); // needed to process release now
GMFMOD_Check("Flushing commands");

GMFMOD_Assert(edmusic.getInstanceCount(), 1, "Get Instance Count matches");
GMFMOD_Check("Getting instance count");

edmusic.releaseAllInstances();
GMFMOD_Check("Releasing all music instances");
studio.flushCommands();
GMFMOD_Check("Flushing commands");

GMFMOD_Assert(edmusic.getInstanceCount(), 0, "All instances released");
GMFMOD_Check("Getting instance count");

// ===== Get Instance List =====
var eimusic1 = edmusic.createInstance();
var eimusic2 = edmusic.createInstance();

GMFMOD_Assert(eimusic1.isValid() && eimusic2.isValid(), true, 
    "Get Instance List: Retrieved valid instances");

var instlist = edmusic.getInstanceList();
GMFMOD_Check("Getting instance list");

var instlistByRef = [];
edmusic.getInstanceList(instlistByRef);
GMFMOD_Check("Getting instance list by ref");

GMFMOD_Assert(array_length(instlist) == array_length(instlistByRef),
    true, "Arrays are equal in length");

var arraysEqual = true;
var allAreValid = true;
for (var i = 0; i < array_length(instlist); ++i)
{
    if (instlist[i].inst_ != instlistByRef[i].inst_)
    {
        arraysEqual = false;
    }
    
    if (!instlist[i].isValid() || !instlistByRef[i].isValid())
    {
        allAreValid = false;
    }
}

GMFMOD_Assert(arraysEqual, true, 
    "Arrays retrieved from getInstanceList are equal");
GMFMOD_Assert(arraysEqual, true, 
    "Instances retrieved from getInstanceList are all valid instances");

eimusic1.release();
eimusic2.release();
studio.flushCommands();
delete eimusic1;
delete eimusic2;

// ====== Load/Unload Sample Data ==============
GMFMOD_Assert(edmusic.getSampleLoadingState(),
    FMOD_STUDIO_LOADING_STATE_UNLOADED,
    "Sample data should start off unloaded with no instances");
GMFMOD_Check("Getting sample loading state");

// Load sample data
edmusic.loadSampleData();
GMFMOD_Check("Loading sample data");
GMFMOD_Assert(edmusic.getSampleLoadingState(),
    FMOD_STUDIO_LOADING_STATE_LOADING,
    "Sample data should start loading after a call to loadSampleData");
 GMFMOD_Check("Getting sample loading state");
 
studio.flushCommands();
GMFMOD_Check("Flushing commands");
studio.flushSampleLoading();
GMFMOD_Check("Flushing sample loading");

GMFMOD_Assert(edmusic.getSampleLoadingState(),
    FMOD_STUDIO_LOADING_STATE_LOADED,
    "Sample data should finish loading after call to flushSampleLoading");
GMFMOD_Check("Getting sample loading state");


// Unload sample data (sample data will not be unloaded until all instances 
// released)
edmusic.unloadSampleData();
GMFMOD_Check("Unloading sample data");

GMFMOD_Assert(edmusic.getSampleLoadingState(),
    FMOD_STUDIO_LOADING_STATE_UNLOADING,
    "Sample data should start unloading after a call to unloadSampleData");
 GMFMOD_Check("Getting sample loading state");
 
studio.flushCommands();
GMFMOD_Check("Flushing commands");
studio.flushSampleLoading();
GMFMOD_Check("Flushing sample loading");
GMFMOD_Assert(edmusic.getSampleLoadingState(),
    FMOD_STUDIO_LOADING_STATE_UNLOADED,
    "Sample data should finish unloading after call to flushSampleLoading");
GMFMOD_Check("Getting sample loading state");

// ====== Is 3D ================================
GMFMOD_Assert(edmusic.is3D(), true, "Music event is 3D: true");
GMFMOD_Check("Getting is 3D: music");

GMFMOD_Assert(edblip.is3D(), false, "Blip sfx is not 3D");
GMFMOD_Check("Getting is 3D: blip sfx");

// ====== Is Oneshot ===========================
GMFMOD_Assert(edmusic.isOneshot(), false, "Music event is oneshot: false");
GMFMOD_Check("Getting is oneshot: music");

GMFMOD_Assert(edblip.isOneshot(), true, "Blip sfx is oneshot: true");
GMFMOD_Check("Getting is oneshot: blip sfx");

// ====== Is Snapshot ==========================
GMFMOD_Assert(edmusic.isSnapshot(), false, "Music event is snapshot: false");
GMFMOD_Check("Getting is snapshot: music");

GMFMOD_Assert(studio.getEvent("snapshot:/TestSnapshot").isSnapshot(), 
    true, "Snapshot test is snapshot: true");
GMFMOD_Check("Getting is snapshot: test snapshot");


// ====== Is Stream ============================
GMFMOD_Assert(edmusic.isStream(), true, "Music event is stream: true");
GMFMOD_Check("Getting is stream: music");

GMFMOD_Assert(edblip.isStream(), false, "Blip sfx is not stream");
GMFMOD_Check("Getting is stream: blip sfx");


// ====== Has Cue ==============================
GMFMOD_Assert(edmusic.hasCue(), false, "Music event has cue: false");
GMFMOD_Check("Getting has cue: music");

GMFMOD_Assert(studio.getEvent("event:/TestCueEvent").hasCue(), 
    true, "Cue test event has cue: true");
GMFMOD_Check("Getting has cue: test cue event");


// ====== Get Max Distance/Min Distance ========
GMFMOD_Assert(edmusic.getMaxDistance(), 20, "Get max dist 3d event");
GMFMOD_Check("Get max distance 3d event");

GMFMOD_Assert(edblip.getMaxDistance(), 0, "Get max dist 2d event");
GMFMOD_Check("Get max distance 2d event");

GMFMOD_Assert(edmusic.getMinDistance(), 1, "Get Min dist 3d event");
GMFMOD_Check("Get Min distance 3d event");

GMFMOD_Assert(edblip.getMinDistance(), 0, "Get max dist 2d event");
GMFMOD_Check("Get max distance 2d event");


// ====== Get Param Description Count ==========
GMFMOD_Assert(edmusic.getParameterDescriptionCount(), 2,
    "Music event param description count is 2");
GMFMOD_Check("Music get param description count");

GMFMOD_Assert(edblip.getParameterDescriptionCount(), 1,
    "Blip event param description count is 1");
GMFMOD_Check("Music get param description count");


// ====== Get Param Description by Name =======
// pass by reference
var pdesc/*: GMFMOD_STUDIO_PARAMETER_DESCRIPTION*/ = 
    new GMFMOD_STUDIO_PARAMETER_DESCRIPTION();
edmusic.getParameterDescriptionByName("Pitch", pdesc);
GMFMOD_Check("Getting parameter description by name");

GMFMOD_Assert(GMFMOD_GetError(), FMOD_OK, 
	"EvDesc Get ParamDesc by name: no errors.");
GMFMOD_Assert(pdesc.name, "Pitch", "EvDesc Get ParamDesc by name: name");
GMFMOD_Assert(pdesc.minimum, 0, "EvDesc Get ParamDesc by name: minimum");
GMFMOD_Assert(pdesc.maximum, 1, "EvDesc Get ParamDesc by name: maximum");
GMFMOD_Assert(instanceof(pdesc.pid), "GMFMOD_STUDIO_PARAMETER_ID", 
	"EvDesc Get ParamDesc by name: pid type");
GMFMOD_Assert(pdesc.defaultvalue, 0.5, 
	"EvDesc Get ParamDesc by name: defaultvalue");
GMFMOD_Assert(pdesc.flags, 0, "EvDesc Get ParamDesc: flags");
delete pdesc;

// get by return value
var pdesc/*: GMFMOD_STUDIO_PARAMETER_DESCRIPTION*/ = 
    edmusic.getParameterDescriptionByName("Pitch", pdesc);
GMFMOD_Check("Getting parameter description by name");

GMFMOD_Assert(GMFMOD_GetError(), FMOD_OK, 
	"EvDesc Get ParamDesc by name: no errors.");
GMFMOD_Assert(pdesc.name, "Pitch", "EvDesc Get ParamDesc by name: name");
GMFMOD_Assert(pdesc.minimum, 0, "EvDesc Get ParamDesc by name: minimum");
GMFMOD_Assert(pdesc.maximum, 1, "EvDesc Get ParamDesc by name: maximum");
GMFMOD_Assert(instanceof(pdesc.pid), "GMFMOD_STUDIO_PARAMETER_ID", 
	"EvDesc Get ParamDesc by name: pid type");
GMFMOD_Assert(pdesc.defaultvalue, 0.5, 
	"EvDesc Get ParamDesc by name: defaultvalue");
GMFMOD_Assert(pdesc.flags, 0, "EvDesc Get ParamDesc: flags");
delete pdesc;

// ====== Get Param Description by Index =======
// pass by reference
var pdesc/*: GMFMOD_STUDIO_PARAMETER_DESCRIPTION*/ = 
    new GMFMOD_STUDIO_PARAMETER_DESCRIPTION();
edmusic.getParameterDescriptionByIndex(0, pdesc);
GMFMOD_Check("Getting parameter description by index: pass by ref");

GMFMOD_Assert(GMFMOD_GetError(), FMOD_OK, 
	"EvDesc Get ParamDesc by index: no errors.");
GMFMOD_Assert(pdesc.name, "RoomSize", "EvDesc Get ParamDesc by index: name");
GMFMOD_Assert(pdesc.minimum, 0, "EvDesc Get ParamDesc by index: minimum");
GMFMOD_Assert(pdesc.maximum, 10, "EvDesc Get ParamDesc by index: maximum");
GMFMOD_Assert(instanceof(pdesc.pid), "GMFMOD_STUDIO_PARAMETER_ID", 
	"EvDesc Get ParamDesc by index: pid type");
GMFMOD_Assert(pdesc.defaultvalue, 0, 
	"EvDesc Get ParamDesc by index: defaultvalue");
GMFMOD_Assert(pdesc.flags, 0, "EvDesc Get ParamDesc: flags");
delete pdesc;

// get by return value
var pdesc/*: GMFMOD_STUDIO_PARAMETER_DESCRIPTION*/ = 
    edmusic.getParameterDescriptionByIndex(0, pdesc);
GMFMOD_Check("Getting parameter description by index: returned from func");

GMFMOD_Assert(GMFMOD_GetError(), FMOD_OK, 
	"EvDesc Get ParamDesc by index: no errors.");
GMFMOD_Assert(pdesc.name, "RoomSize", "EvDesc Get ParamDesc by index: name");
GMFMOD_Assert(pdesc.minimum, 0, "EvDesc Get ParamDesc by index: minimum");
GMFMOD_Assert(pdesc.maximum, 10, "EvDesc Get ParamDesc by index: maximum");
GMFMOD_Assert(instanceof(pdesc.pid), "GMFMOD_STUDIO_PARAMETER_ID", 
	"EvDesc Get ParamDesc by index: pid type");
GMFMOD_Assert(pdesc.defaultvalue, 0, 
	"EvDesc Get ParamDesc by index: defaultvalue");
GMFMOD_Assert(pdesc.flags, 0, "EvDesc Get ParamDesc: flags");
delete pdesc;

// ====== Get Param Description by ID ==========
// get the desc to get id
var pdesc = new GMFMOD_STUDIO_PARAMETER_DESCRIPTION();
edmusic.getParameterDescriptionByName("Pitch", pdesc);
GMFMOD_Check("Getting param description by name");

// pass by reference
var pdesc_fromid = new GMFMOD_STUDIO_PARAMETER_DESCRIPTION();
edmusic.getParameterDescriptionByID(pdesc.pid, pdesc_fromid);
GMFMOD_Check("Getting param description by id");

GMFMOD_Assert(pdesc_fromid.name, pdesc.name, 
	"EvDesc Get ParamDesc by ID: name");
GMFMOD_Assert(pdesc_fromid.minimum, pdesc.minimum, 
	"EvDesc Get ParamDesc by ID: minimum");
GMFMOD_Assert(pdesc_fromid.maximum, pdesc.maximum, 
	"EvDesc Get ParamDesc by ID: maximum");
GMFMOD_Assert(instanceof(pdesc_fromid.pid), instanceof(pdesc.pid), 
	"EvDesc Get ParamDesc by ID: pid type");
GMFMOD_Assert(pdesc_fromid.defaultvalue, pdesc.defaultvalue,
	"EvDesc Get ParamDesc by ID: defaultvalue");
GMFMOD_Assert(pdesc_fromid.flags, pdesc.flags, 
	"EvDesc Get ParamDesc by ID: flags");
delete pdesc_fromid;

// get by return
var pdesc_fromid = edmusic.getParameterDescriptionByID(pdesc.pid, pdesc_fromid);
GMFMOD_Check("Getting param description by id");

GMFMOD_Assert(pdesc_fromid.name, pdesc.name, 
	"EvDesc Get ParamDesc by ID: name");
GMFMOD_Assert(pdesc_fromid.minimum, pdesc.minimum, 
	"EvDesc Get ParamDesc by ID: minimum");
GMFMOD_Assert(pdesc_fromid.maximum, pdesc.maximum, 
	"EvDesc Get ParamDesc by ID: maximum");
GMFMOD_Assert(instanceof(pdesc_fromid.pid), instanceof(pdesc.pid), 
	"EvDesc Get ParamDesc by ID: pid type");
GMFMOD_Assert(pdesc_fromid.defaultvalue, pdesc.defaultvalue,
	"EvDesc Get ParamDesc by ID: defaultvalue");
GMFMOD_Assert(pdesc_fromid.flags, pdesc.flags, 
	"EvDesc Get ParamDesc by ID: flags");
delete pdesc_fromid;
delete pdesc;

// ====== Get User Property ====================
// pass by reference
var userprop = new GMFMOD_STUDIO_USER_PROPERTY();
edblip.getUserProperty("stringprop", userprop);
GMFMOD_Check("Getting user property");

GMFMOD_Assert(userprop.name, "stringprop", 
	"EvDesc Get User Property String: name");
GMFMOD_Assert(userprop.value, "Hello World!", 
	"EvDesc Get User Property String: value");
GMFMOD_Assert(userprop.type, FMOD_STUDIO_USER_PROPERTY_TYPE_STRING,
	"EvDesc Get User Property String: type");
delete userprop;

userprop = edblip.getUserProperty("floatprop");
GMFMOD_Check("Getting user property");

GMFMOD_Assert(userprop.name, "floatprop", 
	"EvDesc Get User Property Float: name");
GMFMOD_Assert(userprop.value, 1.234, 
	"EvDesc Get User Property Float: value");
GMFMOD_Assert(userprop.type, FMOD_STUDIO_USER_PROPERTY_TYPE_FLOAT,
	"EvDesc Get User Property Float: type");
delete userprop;


// ====== Get User Property by Index ===========
// pass by reference
var userprop = new GMFMOD_STUDIO_USER_PROPERTY();
edblip.getUserPropertyByIndex(0, userprop);
GMFMOD_Check("Getting user property by index");

GMFMOD_Assert(userprop.name, "boolprop", 
	"EvDesc Get User Property boolprop: name");
GMFMOD_Assert(userprop.value, 0, 
	"EvDesc Get User Property boolprop: value");
GMFMOD_Assert(userprop.type, FMOD_STUDIO_USER_PROPERTY_TYPE_FLOAT,
	"EvDesc Get User Property boolprop: type");
delete userprop;

// return by value
userprop = edblip.getUserPropertyByIndex(0);
GMFMOD_Check("Getting user property");

GMFMOD_Assert(userprop.name, "boolprop", 
	"EvDesc Get User Property boolprop: name");
GMFMOD_Assert(userprop.value, 0, 
	"EvDesc Get User Property boolprop: value");
GMFMOD_Assert(userprop.type, FMOD_STUDIO_USER_PROPERTY_TYPE_FLOAT,
	"EvDesc Get User Property boolprop: type");
delete userprop;


// ====== Get User Property Count ==============
GMFMOD_Assert(edmusic.getUserPropertyCount(), 2, 
	"EvDesc Get User Property Count: props 1");
GMFMOD_Check("Getting user property count: music");
	
GMFMOD_Assert(edblip.getUserPropertyCount(), 4, 
	"EvDesc Get User Property Count: props 4");
GMFMOD_Check("Getting user property count: blip");


// ====== Get ID ===============================
var guid = new GMFMOD_GUID();
edmusic.getID(guid);
GMFMOD_Check("Getting guid");

GMFMOD_Assert(guid.data1, $4fa3eda1, "EvDesc Get ID: data1");
GMFMOD_Assert(guid.data2, $884b, "EvDesc Get ID: data2");
GMFMOD_Assert(guid.data3, $4305, "EvDesc Get ID: data3");
GMFMOD_Assert(guid.data4[0], $84, "EvDesc Get ID: data4[0]");
GMFMOD_Assert(guid.data4[1], $16, "EvDesc Get ID: data4[1]");
GMFMOD_Assert(guid.data4[2], $41, "EvDesc Get ID: data4[2]");
GMFMOD_Assert(guid.data4[3], $66, "EvDesc Get ID: data4[3]");
GMFMOD_Assert(guid.data4[4], $95, "EvDesc Get ID: data4[4]");
GMFMOD_Assert(guid.data4[5], $88, "EvDesc Get ID: data4[5]");
GMFMOD_Assert(guid.data4[6], $64, "EvDesc Get ID: data4[6]");
GMFMOD_Assert(guid.data4[7], $5d, "EvDesc Get ID: data4[7]");
delete guid;

guid = edblip.getID();
GMFMOD_Check("Getting guid");

GMFMOD_Assert(guid.data1, $66fd7e65, "EvDesc Get ID 2: data1");
GMFMOD_Assert(guid.data2, $d2f3, "EvDesc Get ID 2: data2");
GMFMOD_Assert(guid.data3, $4b7b, "EvDesc Get ID 2: data3");
GMFMOD_Assert(guid.data4[0], $bc, "EvDesc Get ID 2: data4[0]");
GMFMOD_Assert(guid.data4[1], $38, "EvDesc Get ID 2: data4[1]");
GMFMOD_Assert(guid.data4[2], $91, "EvDesc Get ID 2: data4[2]");
GMFMOD_Assert(guid.data4[3], $3c, "EvDesc Get ID 2: data4[3]");
GMFMOD_Assert(guid.data4[4], $0d, "EvDesc Get ID 2: data4[4]");
GMFMOD_Assert(guid.data4[5], $b7, "EvDesc Get ID 2: data4[5]");
GMFMOD_Assert(guid.data4[6], $10, "EvDesc Get ID 2: data4[6]");
GMFMOD_Assert(guid.data4[7], $9c, "EvDesc Get ID 2: data4[7]");
delete guid;


// ====== Get Length ===========================
GMFMOD_Assert(edmusic.getLength() > 60000, true,
    "Get length: music is greater than a minute");
GMFMOD_Check("Getting event length");

GMFMOD_Assert(edblip.getLength() < 500, true,
    "Get length: blip is less than .5 seconds");
GMFMOD_Check("Getting event length");


// ====== Get Path =============================
GMFMOD_Assert(edmusic.getPath(), "event:/Music",
    "Get path: music");
GMFMOD_Check("Getting path for music event");

GMFMOD_Assert(edblip.getPath(), "event:/UIBlip",
    "Get path: blip");
GMFMOD_Check("Getting path for blip event");

// ====== Set Callback =========================
edmusic.setCallback(FMOD_STUDIO_EVENT_CALLBACK_TIMELINE_BEAT);
GMFMOD_Check("Setting callback with timeline beat mask");

inst = edmusic.createInstance();
inst.start();