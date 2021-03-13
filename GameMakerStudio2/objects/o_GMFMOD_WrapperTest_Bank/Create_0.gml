/// @description Bank General Tests

// Inherit the parent event
event_inherited();

 // ========== Bank Load File ==========
bank = /// @is {GMFMOD_Studio_Bank}
    studio.loadBankFile("soundbanks/Desktop/Master_ENG.bank",  
    FMOD_STUDIO_LOAD_BANK_NONBLOCKING);

GMFMOD_Check("Loading Master Bank");
GMFMOD_Assert(bank.isValid(), true, "Bank is valid");

stringsbank = /// @is {GMFMOD_Studio_Bank}
    studio.loadBankFile("soundbanks/Desktop/Master_ENG.strings.bank", 
    FMOD_STUDIO_LOAD_BANK_NORMAL);

GMFMOD_Check("Loading Master Strings Bank");
GMFMOD_Assert(stringsbank.isValid(), true, "Bank is valid");


// ===== Sample Loading =====
// Load Samples
bank.loadSampleData();
GMFMOD_Check("Loading sample data");

GMFMOD_Assert(bank.getSampleLoadingState(), FMOD_STUDIO_LOADING_STATE_LOADING,
    "Sample state is loading");
GMFMOD_Check("Getting sample loading state");

studio.flushSampleLoading();
GMFMOD_Check("Flushing sample loading");

GMFMOD_Assert(bank.getSampleLoadingState(), FMOD_STUDIO_LOADING_STATE_LOADED,
    "Sample state is loaded");
GMFMOD_Check("Getting sample loading state");

// Unload Samples
bank.unloadSampleData();
GMFMOD_Check("Unloading sample data");

GMFMOD_Assert(bank.getSampleLoadingState(), FMOD_STUDIO_LOADING_STATE_UNLOADING,
    "Sample state is unloading");

studio.flushSampleLoading();
GMFMOD_Check("Flusing sample loading");

GMFMOD_Assert(bank.getSampleLoadingState(), FMOD_STUDIO_LOADING_STATE_UNLOADED,
    "Sample state is unloaded");


// ===== Get Busses =====
// Get count
var count = bank.getBusCount();
GMFMOD_Check("Getting bus count");
GMFMOD_Assert(is_numeric(count), true, "Bus count is numeric");

// Get list
var arr = bank.getBusList();
GMFMOD_Check("Getting bus list");

GMFMOD_Assert(is_array(arr), true, "Bus list is an array");
GMFMOD_Assert(array_length(arr), count, 
    "Bus list length and count match");

var areValid = true;
for (var i = 0; i < count; ++i)
{
    if (!arr[i].isValid())
    {
        areValid = false;
        break;
    }
}
GMFMOD_Assert(areValid, true, "Busses retrieved are valid");



// ===== Get Events =====
// Get count
var count = bank.getEventCount();
GMFMOD_Check("Getting event count");
GMFMOD_Assert(is_numeric(count), true, "Event count is numeric");

// Get list
var arr = bank.getEventList();
GMFMOD_Check("Getting event list");

GMFMOD_Assert(is_array(arr), true, "Event list is an array");
GMFMOD_Assert(array_length(arr), count, 
    "Event list length and count match");

var areValid = true;
for (var i = 0; i < count; ++i)
{
    if (!arr[i].isValid())
    {
        show_message("Event invalid ptr: " + string(arr[i]));
        areValid = false;
        break;
    }
}
GMFMOD_Assert(areValid, true, "Events retrieved are valid");



// ===== Get VCAs =====
// Get count
var count = bank.getVCACount();
GMFMOD_Check("Getting VCA count");
GMFMOD_Assert(is_numeric(count), true, "VCA count is numeric");

// Get list
var arr = bank.getVCAList();
GMFMOD_Check("Getting VCA list");

GMFMOD_Assert(is_array(arr), true, "VCA list is an array");
GMFMOD_Assert(array_length(arr), count, 
    "VCA list length and count match");

var areValid = true;
for (var i = 0; i < count; ++i)
{
    if (!arr[i].isValid())
    {
        areValid = false;
        break;
    }
}
GMFMOD_Assert(areValid, true, "VCAs retrieved are valid");



// ===== Get String Info =====
var count = bank.getStringCount();
GMFMOD_Check("Getting string count");
GMFMOD_Assert(is_numeric(count), true, "String count is numeric");

var guid1 = new GMFMOD_GUID();
var guid2 = new GMFMOD_GUID();
for (var i = 0; i < count; ++i)
{
    var path1 = bank.getStringInfoPath(i);
    GMFMOD_Check("Getting string info path");
    bank.getStringInfoID(i, guid1);
    GMFMOD_Check("Getting string info id");
    
    studio.lookupID(path1, guid2);
    GMFMOD_Check("Looking up studio GUID from path");
    var path2 = studio.lookupPath(guid2);
    GMFMOD_Check("Looking up studio Path from GUID");
    
    GMFMOD_Assert(guid1.equals(guid2), true, "String info GUIDs match");
    GMFMOD_Assert(path1, path2, "String info paths match");
}

delete guid1;
delete guid2;



// ===== Get ID =====
var guid = new GMFMOD_GUID();
bank.getID(guid);
GMFMOD_Check("Getting bank guid");

GMFMOD_Assert(guid.data1, $d61eb928, "Bank Get ID: data1");
GMFMOD_Assert(guid.data2, $1d29, "Bank Get ID: data2");
GMFMOD_Assert(guid.data3, $4449, "Bank Get ID: data3");
GMFMOD_Assert(guid.data4[0], $b4, "Bank Get ID: data4[0]");
GMFMOD_Assert(guid.data4[1], $30, "Bank Get ID: data4[1]");
GMFMOD_Assert(guid.data4[2], $5b, "Bank Get ID: data4[2]");
GMFMOD_Assert(guid.data4[3], $77, "Bank Get ID: data4[3]");
GMFMOD_Assert(guid.data4[4], $6d, "Bank Get ID: data4[4]");
GMFMOD_Assert(guid.data4[5], $56, "Bank Get ID: data4[5]");
GMFMOD_Assert(guid.data4[6], $13, "Bank Get ID: data4[6]");
GMFMOD_Assert(guid.data4[7], $47, "Bank Get ID: data4[7]");
delete guid;

guid = bank.getID();
GMFMOD_Check("Getting bank guid");

GMFMOD_Assert(guid.data1, $d61eb928, "Bank Get ID: data1");
GMFMOD_Assert(guid.data2, $1d29, "Bank Get ID: data2");
GMFMOD_Assert(guid.data3, $4449, "Bank Get ID: data3");
GMFMOD_Assert(guid.data4[0], $b4, "Bank Get ID: data4[0]");
GMFMOD_Assert(guid.data4[1], $30, "Bank Get ID: data4[1]");
GMFMOD_Assert(guid.data4[2], $5b, "Bank Get ID: data4[2]");
GMFMOD_Assert(guid.data4[3], $77, "Bank Get ID: data4[3]");
GMFMOD_Assert(guid.data4[4], $6d, "Bank Get ID: data4[4]");
GMFMOD_Assert(guid.data4[5], $56, "Bank Get ID: data4[5]");
GMFMOD_Assert(guid.data4[6], $13, "Bank Get ID: data4[6]");
GMFMOD_Assert(guid.data4[7], $47, "Bank Get ID: data4[7]");
delete guid;


// ===== Bank get path =====
GMFMOD_Assert(bank.getPath(), "bank:/Master", "Bank path matches");
GMFMOD_Check("Getting bank path");
