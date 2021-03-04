// Inherit the parent event
event_inherited();

// Bank loading
fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL);
	
fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.strings.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL);

vca = GMFMS_Ptr(fmod_studio_system_get_vca(studio, "vca:/TestVCA"));
GMFMS_Check("Getting VCA");

GMFMS_Assert(fmod_studio_vca_is_valid(vca), true, "VCA is valid");

// ============================================================================
// VCA Set/Get Volume
// ============================================================================
GMFMS_Assert(fmod_studio_vca_get_volume(vca), 1, 
    "VCA set/get volume matches");
GMFMS_Check("VCA get volume: no errors");
fmod_studio_vca_set_volume(vca, 3);
GMFMS_Check("VCA set volume: no errors");

GMFMS_Assert(fmod_studio_vca_get_volume(vca), 3, 
    "VCA set/get volume matches");
GMFMS_Check("VCA get volume: no errors");

fmod_studio_system_flush_commands(studio);
GMFMS_Check("VCA get volume final: update no errors");

show_debug_message("fmod_studio_vca_volume_final always results in 1, may be " +
    "a bug on FMOD's side");
GMFMS_Assert(fmod_studio_vca_get_volume_final(vca), 1, 
    "VCA get volume final");
GMFMS_Check("VCA get volume final: no errors");

// ============================================================================
// Vca Get Id
// ============================================================================
var buf = GMFMS_GetBuffer();
fmod_studio_vca_get_id(vca, buf.getAddress());
GMFMS_Check("VCA Get ID: no errors");

var guid = new GMFMS_GUID(buf);

GMFMS_Assert(guid.data1, $498278ec, "Vca Get ID: data1");
GMFMS_Assert(guid.data2, $60ce, "Vca Get ID: data2");
GMFMS_Assert(guid.data3, $42c9, "Vca Get ID: data3");
GMFMS_Assert(guid.data4[0], $ad, "Vca Get ID: data4[0]");
GMFMS_Assert(guid.data4[1], $6d, "Vca Get ID: data4[1]");
GMFMS_Assert(guid.data4[2], $96, "Vca Get ID: data4[2]");
GMFMS_Assert(guid.data4[3], $97, "Vca Get ID: data4[3]");
GMFMS_Assert(guid.data4[4], $f5, "Vca Get ID: data4[4]");
GMFMS_Assert(guid.data4[5], $b9, "Vca Get ID: data4[5]");
GMFMS_Assert(guid.data4[6], $08, "Vca Get ID: data4[6]");
GMFMS_Assert(guid.data4[7], $40, "Vca Get ID: data4[7]");

delete guid;

// ============================================================================
// Vca Get Path
// ============================================================================
GMFMS_Assert(fmod_studio_vca_get_path(vca), "vca:/TestVCA",
    "VCA get path: matches");
GMFMS_Check("VCA get path: no errors");

timer = 0;	