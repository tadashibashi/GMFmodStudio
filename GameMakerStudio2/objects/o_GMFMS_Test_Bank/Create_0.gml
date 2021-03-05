event_inherited();
// ============================================================================
// Bank Loading
// functions:
//     bank_is_valid
//     get_loading_state
//     unload
// ============================================================================
bank = GMFMOD_Ptr(fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL));
GMFMS_Check("Loading Master_ENG.bank");
fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.strings.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL);
GMFMS_Check("Loading Master_ENG.strings.bank");

// Check bank validity
GMFMS_Assert(fmod_studio_bank_is_valid(bank), true, "Master Bank: is valid");

GMFMS_Assert(
    fmod_studio_bank_get_loading_state(bank), 
    FMOD_STUDIO_LOADING_STATE_LOADED,
    "Get Loaded State: is loaded");
GMFMS_Check("Getting Loading State: no errors");

fmod_studio_bank_unload(bank);
GMFMS_Check("Unloading Bank: no errors");

GMFMS_Assert(
    fmod_studio_bank_get_loading_state(bank), 
    FMOD_STUDIO_LOADING_STATE_UNLOADING,
    "Get Loaded State: unloaded");
GMFMS_Check("Getting Loading State: no errors");

fmod_studio_system_flush_commands(studio);
GMFMS_Check("Unloading Bank: flushing commands");

bank = GMFMOD_Ptr(fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL));
GMFMS_Check("Loading Master_ENG.bank");

// ============================================================================
// Bank Sample Loading
// functions:
//     load_sample_data
//     unload_sample_data
//     get_sample_loading_state
// ============================================================================
// Loading
fmod_studio_bank_load_sample_data(bank);
GMFMS_Check("Loading Sample Data: no errors");
GMFMS_Assert(
    fmod_studio_bank_get_sample_loading_state(bank), 
    FMOD_STUDIO_LOADING_STATE_LOADING,
    "Getting Sample Loading State: loading");
GMFMS_Check("Getting Sample Loading State: no errors");

fmod_studio_system_flush_sample_loading(studio);
GMFMS_Check("Flush sample loading: no errors");

GMFMS_Assert(
    fmod_studio_bank_get_sample_loading_state(bank), 
    FMOD_STUDIO_LOADING_STATE_LOADED,
    "Getting Sample Loading State: loaded");

// Unloading
fmod_studio_bank_unload_sample_data(bank);
GMFMS_Check("Unloading Sample Data: no errors");
GMFMS_Assert(
    fmod_studio_bank_get_sample_loading_state(bank), 
    FMOD_STUDIO_LOADING_STATE_UNLOADING,
    "Getting Sample Loading State: unloading");
GMFMS_Check("Getting Sample Loading State: no errors");

fmod_studio_system_flush_sample_loading(studio);
GMFMS_Check("Flush sample loading: no errors");

GMFMS_Assert(
    fmod_studio_bank_get_sample_loading_state(bank), 
    FMOD_STUDIO_LOADING_STATE_UNLOADED,
    "Getting Sample Loading State: unloaded");

// ============================================================================
// Bank Get Busses
// functions:
//     get_bus_count
//     get_bus_list
// ============================================================================
var buscount = fmod_studio_bank_get_bus_count(bank);
GMFMS_Check("Bank Get Bus Count: no errors");

var buf = GMFMOD_GetBuffer();
fmod_studio_bank_get_bus_list(bank, buf.getSize()/8, buf.getAddress());
GMFMS_Check("Get Bus List: no errors");

for (var i = 0; i < buscount; ++i)
{
    GMFMS_Assert(
        fmod_studio_bus_is_valid(GMFMOD_Ptr(buf.read(buffer_u64))), 
        true,
        "Bus retrieved is valid");
}

// ============================================================================
// Bank Get Events
// functions:
//     get_event_count
//     get_event_list
// ============================================================================
var eventcount = fmod_studio_bank_get_event_count(bank);
GMFMS_Check("Bank Get Event Count: no errors");

var buf = GMFMOD_GetBuffer();
fmod_studio_bank_get_event_list(bank, buf.getSize()/8, buf.getAddress());
GMFMS_Check("Get Event List: no errors");

for (var i = 0; i < eventcount; ++i)
{
    GMFMS_Assert(
        fmod_studio_evdesc_is_valid(GMFMOD_Ptr(buf.read(buffer_u64))), 
        true,
        "Event retrieved is valid");
}

// ============================================================================
// Bank Get vcas
// functions:
//     get_vca_count
//     get_vca_list
// ============================================================================
var vcacount = fmod_studio_bank_get_vca_count(bank);
GMFMS_Check("Bank Get Vca Count: no errors");

var buf = GMFMOD_GetBuffer();
fmod_studio_bank_get_vca_list(bank, buf.getSize()/8, buf.getAddress());
GMFMS_Check("Get vca List: no errors");

for (var i = 0; i < vcacount; ++i)
{
    GMFMS_Assert(
        fmod_studio_vca_is_valid(GMFMOD_Ptr(buf.read(buffer_u64))), 
        true,
        "vca retrieved is valid");
}

// ============================================================================
// Bank Get String Info
// functions:
//     get_string_info_path
//     get_string_info_id
//     get_string_count
// ============================================================================
var strcount = fmod_studio_bank_get_string_count(bank);
GMFMS_Check("Get string count: no errors");

var guid = new GMFMOD_GUID();
var guid2 = new GMFMOD_GUID();
var buf = GMFMOD_GetBuffer();
for (var i = 0; i < strcount; ++i)
{
    var path = fmod_studio_bank_get_string_info_path(bank, i);
    GMFMS_Check("Get string info path: no errors");
    GMFMS_Assert(
        string_length(path) > 0,
        true,
        "Get string info path");
    fmod_studio_bank_get_string_info_id(bank, buf.getAddress(), i);
    GMFMS_Check("Get string info id: no errors");
    guid.readFromBuffer(buf);
    
    buf.seekReset();
    fmod_studio_system_lookup_id(studio, path, buf.getAddress());
    GMFMS_Check("Get string info: system lookup id no errors");
    guid2.readFromBuffer(buf);
    buf.seekReset();
    guid.writetoBuffer(buf);
    var path2 = fmod_studio_system_lookup_path(studio, buf.getAddress());
    GMFMS_Check("Get string info: system lookup path no errors");
    
    GMFMS_Assert(guid.equals(guid2), true, "String Info: guids match");
    GMFMS_Assert(path, path2, "String Info: strings match");
}

delete guid;
delete guid2;

// ============================================================================
// Bank Get ID
// functions:
//     get_id
// ============================================================================
var buf = GMFMOD_GetBuffer();
var guid = new GMFMOD_GUID();

fmod_studio_bank_get_id(bank, buf.getAddress());
GMFMS_Check("Bank Get ID: no errors");

guid.readFromBuffer(buf);

GMFMS_Assert(guid.data1, $d61eb928, "Bank Get ID: data1");
GMFMS_Assert(guid.data2, $1d29, "Bank Get ID: data2");
GMFMS_Assert(guid.data3, $4449, "Bank Get ID: data3");
GMFMS_Assert(guid.data4[0], $b4, "Bank Get ID: data4[0]");
GMFMS_Assert(guid.data4[1], $30, "Bank Get ID: data4[1]");
GMFMS_Assert(guid.data4[2], $5b, "Bank Get ID: data4[2]");
GMFMS_Assert(guid.data4[3], $77, "Bank Get ID: data4[3]");
GMFMS_Assert(guid.data4[4], $6d, "Bank Get ID: data4[4]");
GMFMS_Assert(guid.data4[5], $56, "Bank Get ID: data4[5]");
GMFMS_Assert(guid.data4[6], $13, "Bank Get ID: data4[6]");
GMFMS_Assert(guid.data4[7], $47, "Bank Get ID: data4[7]");

delete guid;

// ============================================================================
// Bank Get Path
// functions:
//     get_path
// ============================================================================
GMFMS_Assert(fmod_studio_bank_get_path(bank), "bank:/Master",
    "Bank Get Path: matches");
GMFMS_Check("Bank Get Path: no errors");



timer = 0;