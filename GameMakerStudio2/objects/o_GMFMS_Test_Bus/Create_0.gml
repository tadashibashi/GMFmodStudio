event_inherited();

// Load Banks
// Preliminary Bank Loading
fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL);
GMFMS_Check("Loading Master_ENG.bank");
fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.strings.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL);
GMFMS_Check("Loading Master_ENG.strings.bank");

// Get Master Bus
bus = GMFMS_Ptr(fmod_studio_system_get_bus(studio, "bus:/"));
GMFMS_Check("Get Master Bus");
GMFMS_Assert(fmod_studio_bus_is_valid(bus), true, "Get Master Bus: is valid");

// ============================================================================
// Bus Set/Get Paused
// ============================================================================
fmod_studio_bus_set_paused(bus, true);
GMFMS_Check("FMOD Studio Bus Set Paused: true, no errors");

GMFMS_Assert(fmod_studio_bus_get_paused(bus), true, "Bus Get Paused: true");
GMFMS_Check("FMOD Studio Bus Get Paused: true, no errors");

fmod_studio_bus_set_paused(bus, false);
GMFMS_Check("FMOD Studio Bus Set Paused: false, no errors");

GMFMS_Assert(fmod_studio_bus_get_paused(bus), false, "Bus Get Paused: false");
GMFMS_Check("FMOD Studio Bus Get Paused: false, no errors");

// ============================================================================
// Bus Stop All Events
// ============================================================================
fmod_studio_bus_stop_all_events(bus, FMOD_STUDIO_STOP_ALLOWFADEOUT);
GMFMS_Check("Bus Stop All Events");

// ============================================================================
// Bus Set/Get Volume
// ============================================================================
fmod_studio_bus_set_volume(bus, .789);
GMFMS_Check("FMOD Studio Bus Set Volume, no errors");

GMFMS_Assert(fmod_studio_bus_get_volume(bus), .789, "Bus Get Volume Matches");
GMFMS_Check("FMOD Studio Bus Get Volume: no errors");

fmod_studio_bus_set_volume(bus, 1.0);
fmod_studio_system_flush_commands(studio);

GMFMS_Assert(
    fmod_studio_bus_get_volume_final(bus) > .789, 
    true,
    "Bus Get Volume Final");
GMFMS_Check("FMOD Studio Bus Get Volume Final: no errors");

// ============================================================================
// Bus Set/Get Mute
// ============================================================================
fmod_studio_bus_set_mute(bus, true);
GMFMS_Check("FMOD Studio Bus Set mute: true, no errors");

GMFMS_Assert(fmod_studio_bus_get_mute(bus), true, "Bus Get mute: true");
GMFMS_Check("FMOD Studio Bus Get mute: true, no errors");

fmod_studio_bus_set_mute(bus, false);
GMFMS_Check("FMOD Studio Bus Set mute: false, no errors");

GMFMS_Assert(fmod_studio_bus_get_mute(bus), false, "Bus Get mute: false");
GMFMS_Check("FMOD Studio Bus Get mute: false, no errors");



// ============================================================================
// Bus Lock/Unlock Channel Group, Get Channel Group
// ============================================================================
fmod_studio_bus_lock_channel_group(bus);
GMFMS_Check("Bus channel group locked");

fmod_studio_system_flush_commands(studio);
GMFMS_Check("Bus channel group locked: flushing commands");

GMFMS_Assert(fmod_studio_bus_get_channel_group(bus) > 0,true, 
    "Get Channel Group retrieves a pointer");
GMFMS_Check("Get Channel Group");

fmod_studio_bus_unlock_channel_group(bus);
GMFMS_Check("Bus channel group unlocked");

fmod_studio_system_flush_commands(studio);
GMFMS_Check("Bus channel group locked: flushing commands");

// ============================================================================
// Bus Get CPUUsage
// ============================================================================
fmod_studio_bus_get_cpu_usage_exclusive(bus);
GMFMS_Check("Bus Get CPUUsage Exclusive: no errors");
fmod_studio_bus_get_cpu_usage_inclusive(bus);
GMFMS_Check("Bus Get CPUUsage Inclusive: no errors");

// ============================================================================
// Bus Get Memory Usage
// ============================================================================
buf = GMFMS_GetBuffer();

fmod_studio_bus_get_memory_usage(bus, buf.getAddress());
GMFMS_Check("Bus Get Memory Usage: no errors");

var memusage = new GMFMS_MemUsage(buf);
GMFMS_Assert(memusage.exclusive != -1, true, "Bus Get Memory Usage: exclusive");
GMFMS_Assert(memusage.inclusive != -1, true, "Bus Get Memory Usage: inclusive");
GMFMS_Assert(memusage.sampledata != -1, true, "Bus Get Memory Usage: sampledata");

delete memusage;

// ============================================================================
// Bus Get Id
// ============================================================================
var buf = GMFMS_GetBuffer();
fmod_studio_bus_get_id(bus, buf.getAddress());
GMFMS_Check("Bus Get ID: no errors");

var guid = new GMFMS_GUID(buf);

GMFMS_Assert(guid.data1, $3052120b, "Bus Get ID: data1");
GMFMS_Assert(guid.data2, $9d99, "Bus Get ID: data2");
GMFMS_Assert(guid.data3, $4272, "Bus Get ID: data3");
GMFMS_Assert(guid.data4[0], $a2, "Bus Get ID: data4[0]");
GMFMS_Assert(guid.data4[1], $00, "Bus Get ID: data4[1]");
GMFMS_Assert(guid.data4[2], $2f, "Bus Get ID: data4[2]");
GMFMS_Assert(guid.data4[3], $b5, "Bus Get ID: data4[3]");
GMFMS_Assert(guid.data4[4], $bd, "Bus Get ID: data4[4]");
GMFMS_Assert(guid.data4[5], $b5, "Bus Get ID: data4[5]");
GMFMS_Assert(guid.data4[6], $66, "Bus Get ID: data4[6]");
GMFMS_Assert(guid.data4[7], $d3, "Bus Get ID: data4[7]");

delete guid;

// ============================================================================
// Bus Get Path
// ============================================================================
GMFMS_Assert(fmod_studio_bus_get_path(bus), "bus:/", "Bus Get Path: matches");
GMFMS_Check("Bus Get Path: no errors");

timer = 0;