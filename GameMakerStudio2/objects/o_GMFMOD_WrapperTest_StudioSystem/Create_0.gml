// Inherit the parent event
event_inherited();
timer = 0;
checkedParamByName = false;
stopped = false;

/* ========================================================================== *
 * StudioSystem: Banks
 * ========================================================================== */
 // ========== Bank Load File ==========
bank = studio.loadBankFile("soundbanks/Desktop/Master_ENG.bank",  /// @is {GMFMOD_Studio_Bank}
    FMOD_STUDIO_LOAD_BANK_NONBLOCKING);
GMFMOD_Check("Loading Master Bank");
GMFMOD_Assert(bank.isValid(), true, "Bank is valid");

stringsbank = studio.loadBankFile("soundbanks/Desktop/Master_ENG.strings.bank", /// @is {GMFMOD_Studio_Bank}
    FMOD_STUDIO_LOAD_BANK_NONBLOCKING); 
GMFMOD_Check("Loading Master Strings Bank");
GMFMOD_Assert(stringsbank.isValid(), true, "Bank is valid");


studio.flushCommands();
GMFMOD_Check("Flushing commands");


// Stall until bank metadata has loaded.
var loadingstate, strloadingstate;
do {
	loadingstate = bank.getLoadingState();
	strloadingstate = stringsbank.getLoadingState();
}
until(loadingstate == FMOD_STUDIO_LOADING_STATE_LOADED &&
   strloadingstate == FMOD_STUDIO_LOADING_STATE_LOADED);
  
GMFMOD_Assert(
	loadingstate == FMOD_STUDIO_LOADING_STATE_LOADED &&
    strloadingstate == FMOD_STUDIO_LOADING_STATE_LOADED,
    true,
    "StudioSystem Load Bank Files");

 // ========== Bank Get ID ==========
var bankguid1/*: GMFMOD_GUID*/ = new GMFMOD_GUID();
bank.getID(bankguid1);
GMFMOD_Check("Getting Bank GUID");

var bankguid2/*: GMFMOD_GUID*/ = bank.getID();

GMFMOD_Assert(bankguid1.data1, $d61eb928, "Bank Get ID: data1");
GMFMOD_Assert(bankguid1.data2, $1d29, "Bank Get ID: data2");
GMFMOD_Assert(bankguid1.data3, $4449, "Bank Get ID: data3");
GMFMOD_Assert(bankguid1.data4[0], $b4, "Bank Get ID: data4[0]");
GMFMOD_Assert(bankguid1.data4[1], $30, "Bank Get ID: data4[1]");
GMFMOD_Assert(bankguid1.data4[2], $5b, "Bank Get ID: data4[2]");
GMFMOD_Assert(bankguid1.data4[3], $77, "Bank Get ID: data4[3]");
GMFMOD_Assert(bankguid1.data4[4], $6d, "Bank Get ID: data4[4]");
GMFMOD_Assert(bankguid1.data4[5], $56, "Bank Get ID: data4[5]");
GMFMOD_Assert(bankguid1.data4[6], $13, "Bank Get ID: data4[6]");
GMFMOD_Assert(bankguid1.data4[7], $47, "Bank Get ID: data4[7]");
GMFMOD_Assert(bankguid1.equals(bankguid2), true, "Fetched GUID's are equal");

// Clean up
delete bankguid1;
delete bankguid2;

// ========= Get Bank by ID ===========
bankguid1 = bank.getID();
GMFMOD_Check("Getting bank via ID from Studio System");
var bank2 = studio.getBankByID(bankguid1);
GMFMOD_Assert(bank2.isValid(), true, "Bank retrieved by ID is valid");

delete bank2;
delete bankguid1;

// ========= Get Bank by Name =========
var bank2 = studio.getBank("bank:/Master");
GMFMOD_Check("Getting bank via path from Studio System");
GMFMOD_Assert(bank2.isValid(), true, "Bank retrieved by path is valid");


// ========= Get Bank Count ===========
GMFMOD_Assert(studio.getBankCount(), 2, "Bank count as expected");
GMFMOD_Check("Getting bank count");

// ========= Get Bank List  ===========
var banklist = [];
studio.getBankList(banklist);
GMFMOD_Check("Getting Bank List");
GMFMOD_Assert(array_length(banklist), 2, "Bank list count is consistent");
for (var i = 0; i < array_length(banklist); ++i)
{
	var currentbank = array_get(banklist, i);
    GMFMOD_Assert(currentbank.isValid(), true, "Bank list banks are valid");
}

// === Unload All (All Banks Unload ===
studio.unloadAll();
studio.flushCommands();

GMFMOD_Check("Unloading all banks from studio system");
GMFMOD_Assert(bank.isValid(), false, "Bank invalidated successfully");
GMFMOD_Assert(stringsbank.isValid(), false, "Bank invalidated successfully");

studio.loadBankFile("soundbanks/Desktop/Master_ENG.bank", 
    FMOD_STUDIO_LOAD_BANK_NORMAL);
GMFMOD_Check("Master bank reloading");
studio.loadBankFile("soundbanks/Desktop/Master_ENG.strings.bank", 
    FMOD_STUDIO_LOAD_BANK_NORMAL);
GMFMOD_Check("Master strings bank reloading");

// ======== Listener Attributes ==========
var attr3d/*: GMFMOD_3D_ATTRIBUTES*/ = new GMFMOD_3D_ATTRIBUTES();
attr3d.position.x = 1;
attr3d.position.y = 2;
attr3d.position.z = 3;
attr3d.velocity.x = 4;
attr3d.velocity.y = 5;
attr3d.velocity.z = 6;
attr3d.forward.x = 0;
attr3d.forward.y = 0;
attr3d.forward.z = 1;
attr3d.up.x = 0;
attr3d.up.y = 1;
attr3d.up.z = 0;

studio.setListenerAttributes(0, attr3d);

var attr3d2/*: GMFMOD_3D_ATTRIBUTES*/ = studio.getListenerAttributes(0);

GMFMOD_Assert(
	attr3d2.position.x == 1 && attr3d2.position.y == 2 && attr3d2.position.z = 3 &&
	attr3d2.velocity.x == 4 && attr3d2.velocity.y == 5 && attr3d2.velocity.z = 6 &&
	attr3d2.forward.x == 0 && attr3d2.forward.y == 0 && attr3d2.forward.z = 1 &&
	attr3d2.up.x == 0 && attr3d2.up.y == 1 && attr3d2.up.z = 0,
	true,
	"Get/Set Studio Listener Attributes");

// Clean up
delete attr3d;
delete attr3d2;

// ======== Get/Set Listener Weight ==========
studio.setListenerWeight(0, .75);
GMFMOD_Check("Setting Listener weight");
GMFMOD_Assert(studio.getListenerWeight(0), .75, "Getting listener weight");

// ======== Get/Set Num Listeners ============
studio.setNumListeners(3);
GMFMOD_Check("Setting num listeners");

GMFMOD_Assert(studio.getNumListeners(), 3, "Get num listeners matches");
GMFMOD_Check("Getting num listeners");

// ======= Get Bus ===========================
var bus/*: GMFMOD_Studio_Bus*/ = studio.getBus("bus:/");
GMFMOD_Check("Getting master bus");
GMFMOD_Assert(bus.isValid(), true, "Got valid bus");

var busByRef/*: GMFMOD_Studio_Bus*/ = new GMFMOD_Studio_Bus();
studio.getBus("bus:/", busByRef);

GMFMOD_Assert(bus.bus_, busByRef.bus_, "Return Bus and pass by ref match");

// Clean up
delete bus;
delete busByRef;

// ====== Get Bus by ID ======================
var guid = new GMFMOD_GUID();
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

bus = studio.getBusByID(guid);
GMFMOD_Check("Getting bus by ID");
GMFMOD_Assert(bus.isValid(), true, "Get bus by ID: got valid bus");

busByRef = new GMFMOD_Studio_Bus();
studio.getBusByID(guid, busByRef);
GMFMOD_Assert(bus.isValid(), true, "Get bus by ID: got valid bus by ref");

GMFMOD_Assert(bus.bus_, busByRef.bus_, "Return bus and ref bus match");

// Clean up
delete bus;
delete busByRef;

// ===== Get Event Description by Path ==========
var evdesc = studio.getEvent("event:/Music");
GMFMOD_Check("Getting music event");
GMFMOD_Assert(evdesc.isValid(), true, "Event Desc retrieved by path is valid");

var evdescByRef/*: GMFMOD_Studio_EventDescription*/ = 
	new GMFMOD_Studio_EventDescription();
studio.getEvent("event:/Music", evdescByRef);
GMFMOD_Check("Getting Event by reference");
GMFMOD_Assert(evdescByRef.isValid(), true, "Event Desc retrieved by path by ref"
	+ "is valid");
	
// Clean up
delete evdesc;
delete evdescByRef;
delete guid;

// ===== Get Event Description by ID ===========
guid = new GMFMOD_GUID();
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

evdesc = studio.getEventByID(guid);
GMFMOD_Check("Getting Event by ID, return val");
GMFMOD_Assert(evdesc.isValid(), true, 
	"EventDesc by ID, return val is valid");

evdescByRef = new GMFMOD_Studio_EventDescription();
studio.getEventByID(guid, evdescByRef);
GMFMOD_Check("Getting Event by ID, pass by ref");
GMFMOD_Assert(evdescByRef.isValid(), true, 
	"EventDesc by ID, pass by ref is valid");

GMFMOD_Assert(evdesc.desc_, evdescByRef.desc_, "EvDesc by return value and ref "
	+ "both contain the same pointer");

// Clean up
delete guid;
delete evdesc;
delete evdescByRef;


// ===== Get/Set Global Parameter by Name =====
studio.setParameterByName("Weather", 2.345, true);
GMFMOD_Check("Setting global parameter Weather");
GMFMOD_Assert(studio.getParameterByName("Weather"), 2.345,
	"Get param by name matches");
studio.flushCommands();
studio.setParameterByName("Weather", 0, false);
studio.flushCommands();
GMFMOD_Assert(studio.getParameterByNameFinal("Weather") < 2.345, true,
	"Get global paramter final value");
GMFMOD_Check("Getting parameter by name final value");
	
// ===== Get Global Parameter Description =====
GMFMOD_Assert(studio.getParameterDescriptionCount(), 2, 
	"Get paramter description count");
GMFMOD_Check("Getting paramter description count");

var paramdesc/*: GMFMOD_STUDIO_PARAMETER_DESCRIPTION*/ = 
	studio.getParameterDescriptionByIndex(0);
GMFMOD_Check("Getting Parameter Description by Index");
paramdesc.log();
GMFMOD_Assert(
	paramdesc.name == "Weather" && paramdesc.maximum == 3 && 
		paramdesc.minimum == 0 && paramdesc.defaultvalue == 1.78 &&
		paramdesc.flags == FMOD_STUDIO_PARAMETER_GLOBAL &&
		is_numeric(paramdesc.pid.data1) && 
		is_numeric(paramdesc.pid.data2),
	true,
	"StudioSystem Get Parameter Description By Index");
delete paramdesc;

paramdesc = new GMFMOD_STUDIO_PARAMETER_DESCRIPTION();
studio.getParameterDescriptionByIndex(0, paramdesc);
GMFMOD_Check("Getting Parameter Description by Index, pass by ref");

GMFMOD_Assert(
	paramdesc.name == "Weather" && paramdesc.maximum == 3 && 
		paramdesc.minimum == 0 && paramdesc.defaultvalue == 1.78 &&
		paramdesc.flags == FMOD_STUDIO_PARAMETER_GLOBAL &&
		is_numeric(paramdesc.pid.data1) && 
		is_numeric(paramdesc.pid.data2),
	true,
	"StudioSystem Get Parameter Description By Index pass by ref");
	
delete paramdesc;

// ===== Get/Set Global Parameter by ID =====
var paramdesc/*: GMFMOD_STUDIO_PARAMETER_DESCRIPTION*/ = studio.getParameterDescriptionByIndex(0);
GMFMOD_Check("Getting parameter description by index");
var paramid/*: GMFMOD_STUDIO_PARAMETER_ID*/ = paramdesc.pid;

studio.setParameterByID(paramid, .12345);
GMFMOD_Check("Setting Parameter by ID");
GMFMOD_Assert(studio.getParameterByID(paramid), .12345, 
	"Get Param by ID are equal");
GMFMOD_Check("Getting Parameter by ID");

delete paramdesc;
delete paramid;

// ===== Set Multiple Global Parameters by IDs =====
var pid0 = studio.getParameterDescriptionByIndex(0).pid;
var pid1 = studio.getParameterDescriptionByIndex(1).pid;

studio.setParametersByIDs([pid0, pid1], [.123, .456], true);
GMFMOD_Check("Setting Parameters by IDs");

GMFMOD_Assert(studio.getParameterByID(pid0), .123, "SetParamsByIDs: Get Param0");
GMFMOD_Assert(studio.getParameterByID(pid1), .456, "SetParamsByIDs: Get Param1");


// ===== Get VCA ==============================================================
// functions:
//		GMFMOD_Studio_System:getVCA
//		GMFMOD_Studio_System:getVCAByID
//

// Get VCA
var vca/*: GMFMOD_Studio_VCA*/ = studio.getVCA("vca:/TestVCA");
GMFMOD_Check("Getting VCA");
GMFMOD_Assert(vca.isValid(), true, "Get VCA retrieves a valid VCA");

// Pass by reference
var vcaByRef/*: GMFMOD_Studio_VCA*/ = new GMFMOD_Studio_VCA();
studio.getVCA("vca:/TestVCA", vcaByRef);
GMFMOD_Check("Getting VCA, pass by ref");
GMFMOD_Assert(vcaByRef.isValid(), true, 
	"Get VCA pass by ref retrieves valid VCA");

GMFMOD_Assert(vca.vca_, vcaByRef.vca_, 
	"VCA returned by value and passed by Ref retrieve the same pointer");

// Clean up
delete vca;
delete vcaByRef;

// Get VCA By ID
guid = new GMFMOD_GUID();
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
vca = studio.getVCAByID(guid);
GMFMOD_Check("Getting VCA by GUID");
GMFMOD_Assert(vca.isValid(), true, "VCA retrieved by ID is valid");

vcaByRef = new GMFMOD_Studio_VCA();
studio.getVCAByID(guid, vcaByRef);
GMFMOD_Check("Getting VCA by GUID");
GMFMOD_Assert(vcaByRef.isValid(), true, "VCA retrieved by ID by ref is valid");
GMFMOD_Assert(vca.vca_, vcaByRef.vca_, 
	"VCA's returned by value and passed by ref retrieve the same pointer");

// Clean up
delete guid;
delete vca;
delete vcaByRef;

// ===== Command Replay =======================================================
// functions:
//		GMFMOD_Studio_System:startCommandCapture
//		GMFMOD_Studio_System:stopCommandCapture
//		GMFMOD_Studio_System:loadCommandReplay
//
studio.startCommandCapture("commandcapture", FMOD_STUDIO_COMMANDCAPTURE_NORMAL);
GMFMOD_Check("Starting CommandCapture");

studio.stopCommandCapture();
GMFMOD_Check("Stopping CommandCapture");

var comrep = studio.loadCommandReplay("commandcapture", 
	FMOD_STUDIO_COMMANDREPLAY_NORMAL);
GMFMOD_Check("Loading Command Replay");
GMFMOD_Assert(comrep.isValid(), true, 
	"Loaded a valid replay object: obtained by return val");

var comrepByRef = new GMFMOD_Studio_CommandReplay();
studio.loadCommandReplay("commandcapture",
	FMOD_STUDIO_COMMANDREPLAY_NORMAL, comrepByRef);
GMFMOD_Check("Loading Command Replay pass by ref");
GMFMOD_Assert(comrepByRef.isValid(), true, 
	"Loaded a valid replay object: obtained by ref");

// Clean up
comrep.release();
comrepByRef.release();
delete comrep;
delete comrepByRef;


// =====  Profiling ===========================================================
// note: must use a logging version of FMOD in order to retrieve values
// functions:
//		GMFMOD_Studio_System:getBufferUsage
//		GMFMOD_Studio_System:resetBufferUsage
//		GMFMOD_Studio_System:getCPUUsage
//		GMFMOD_Studio_System:getMemoryUsage

// Get buffer usage
var bufusage/*: GMFMOD_STUDIO_BUFFER_USAGE*/ = studio.getBufferUsage();
GMFMOD_Check("Getting buffer usage");

var bufusageByRef/*: GMFMOD_STUDIO_BUFFER_USAGE*/ = 
	new GMFMOD_STUDIO_BUFFER_USAGE();
studio.getBufferUsage(bufusageByRef);
GMFMOD_Check("Getting buffer usage by reference");

GMFMOD_Assert(bufusage.studiocommandqueue.currentusage, 
	bufusageByRef.studiocommandqueue.currentusage,
	"Get buffer usage return val and ref comparison: studiocommandqueue");
GMFMOD_Assert(bufusage.studiohandle.currentusage, 
	bufusageByRef.studiohandle.currentusage,
	"Get buffer usage return val and ref comparison: studiohandle");

delete bufusage;
delete bufusageByRef;

// Reset buffer usage
studio.resetBufferUsage();
GMFMOD_Check("Resetting buffer usage");

// Get cpu usage
var cpuusage/*: GMFMOD_STUDIO_CPU_USAGE*/ = studio.getCPUUsage();
GMFMOD_Check("Getting cpu usage");
var cpuusageByRef/*: GMFMOD_STUDIO_CPU_USAGE*/ = new GMFMOD_STUDIO_CPU_USAGE();
studio.getCPUUsage(cpuusageByRef);
GMFMOD_Check("Getting cpu usage by reference");

GMFMOD_Assert(cpuusage.dspusage, cpuusageByRef.dspusage,
	"Comparing cpu usage return by value and ref: dspusage");
GMFMOD_Assert(cpuusage.streamusage, cpuusageByRef.streamusage,
	"Comparing cpu usage return by value and ref: streamusage");
GMFMOD_Assert(cpuusage.geometryusage, cpuusageByRef.geometryusage,
	"Comparing cpu usage return by value and ref: geometryusage");
GMFMOD_Assert(cpuusage.updateusage, cpuusageByRef.updateusage,
	"Comparing cpu usage return by value and ref: updateusage");
GMFMOD_Assert(cpuusage.studiousage, cpuusageByRef.studiousage,
	"Comparing cpu usage return by value and ref: studiousage");

delete cpuusage;
delete cpuusageByRef;

// Get memory usage
var memusage/*: GMFMOD_STUDIO_MEMORY_USAGE*/ = studio.getMemoryUsage();
GMFMOD_Check("Getting studio memory usage");
var memusageByRef/*: GMFMOD_STUDIO_MEMORY_USAGE*/ = new GMFMOD_STUDIO_MEMORY_USAGE();
studio.getMemoryUsage(memusageByRef);
GMFMOD_Check("Getting studio memory usage by reference");

GMFMOD_Assert(memusage.inclusive, memusageByRef.inclusive,
	"Comparing memory usage return/ref: inclusive");
GMFMOD_Assert(memusage.exclusive, memusageByRef.exclusive,
	"Comparing memory usage return/ref: exclusive");
GMFMOD_Assert(memusage.sampledata, memusageByRef.sampledata,
	"Comparing memory usage return/ref: sampledata");

delete memusage;
delete memusageByRef;

// =====  General ==============================================================
// note: must use a logging version of FMOD in order to retrieve values
// functions:
//		GMFMOD_Studio_System:setCallback
//		GMFMOD_Studio_System:getCoreSystem (currently not supported!)
//		GMFMOD_Studio_System:lookupID
//		GMFMOD_Studio_System:lookupPath

// Set callback
studio.setCallback(FMOD_STUDIO_SYSTEM_CALLBACK_PREUPDATE);
GMFMOD_Check("Set Callback: Preupdate");

// Get core system not supported

// Lookup ID
var guid = studio.lookupID("event:/Music");
GMFMOD_Check("Looking up id for event:/Music");
var guidByRef = new GMFMOD_GUID();
studio.lookupID("event:/Music", guidByRef);

GMFMOD_Assert(guid.equals(guidByRef), true, "Lookup guid ret/ref are equal");

var evdesc = studio.getEventByID(guid);
GMFMOD_Check("LookupID: Get Event by ID for validity check");
GMFMOD_Assert(evdesc.isValid(), true, "LookupID: Get Event by ID valid");

studio.getEventByID(guidByRef, evdesc);
GMFMOD_Check("LookupID: Get Event by ID for validity check");
GMFMOD_Assert(evdesc.isValid(), true, "LookupID: Get Event by ID valid");

// Lookup Path
GMFMOD_Assert(studio.lookupPath(guid), "event:/Music", 
	"Lookup Path, matches");
GMFMOD_Assert(studio.lookupPath(guidByRef), "event:/Music", 
	"Lookup Path, matches");