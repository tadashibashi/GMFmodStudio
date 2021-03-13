/// @description Bus General Test

// Inherit the parent event
event_inherited();

bank =        /// @is {GMFMOD_Studio_Bank}
    studio.loadBankFile("soundbanks/Desktop/Master_ENG.bank",  
    FMOD_STUDIO_LOAD_BANK_NORMAL);
GMFMOD_Check("Loading Master Bank");
GMFMOD_Assert(bank.isValid(), true, "Master bank is valid");

stringsbank = /// @is {GMFMOD_Studio_Bank}
    studio.loadBankFile("soundbanks/Desktop/Master_ENG.strings.bank",
    FMOD_STUDIO_LOAD_BANK_NORMAL); 
GMFMOD_Check("Loading Master Strings Bank");
GMFMOD_Assert(stringsbank.isValid(), true, "Strings bank is valid");

bus = studio.getBus("bus:/"); /// @is {GMFMOD_Studio_Bus}
GMFMOD_Check("Getting master bus");
GMFMOD_Assert(bus.isValid(), true, "Master bus is valid");

// ===== Set/Get Paused =====
bus.setPaused(true);
GMFMOD_Check("Setting paused");

GMFMOD_Assert(bus.getPaused(), true, "Paused is true");
GMFMOD_Check("Getting paused");

bus.setPaused(false);
GMFMOD_Check("Setting paused");

GMFMOD_Assert(bus.getPaused(), false, "Paused is false");
GMFMOD_Check("Getting paused");


// ===== Stop all events =====
bus.stopAllEvents(FMOD_STUDIO_STOP_ALLOWFADEOUT);
GMFMOD_Check("Stopping all events");

// ===== Set/Get Volume =====
bus.setVolume(.789);
GMFMOD_Check("Setting volume");

GMFMOD_Assert(bus.getVolume(), .789, "Volume value is as set");
GMFMOD_Check("Getting volume");

bus.setVolume(1);
GMFMOD_Check("Setting volume to 1");

// volume final value is not asynchronous

GMFMOD_Assert(bus.getVolumeFinal() > .789, true, "Volume final value updated");
GMFMOD_Check("Getting final volume value");

// ===== Set/Get Mute =====
bus.setMute(true);
GMFMOD_Check("Setting mute");

GMFMOD_Assert(bus.getMute(), true, "Mute is true");
GMFMOD_Check("Getting mute");

bus.setMute(false);
GMFMOD_Check("Setting mute");

GMFMOD_Assert(bus.getMute(), false, "Mute is false");
GMFMOD_Check("Getting mute");

// ===== Lock/Unlock channel group
bus.lockChannelGroup();
GMFMOD_Check("Locking channel group");

studio.flushCommands();
GMFMOD_Check("Flushing commands");

bus.unlockChannelGroup();
GMFMOD_Check("Unlocking channel group");

studio.flushCommands();
GMFMOD_Check("Flushing commands");

// ===== Get CPUUsage =====
GMFMOD_Assert(is_numeric(bus.getCPUUsage(true)), true, 
    "CPUUsage exclusive is numeric");
GMFMOD_Check("Getting CPUUsage exclusive");

GMFMOD_Assert(is_numeric(bus.getCPUUsage(false)), true, 
    "CPUUsage inclusive is numeric");
GMFMOD_Check("Getting CPUUsage inclusive");

// ===== Get Memory Usage =====
var memusage = new GMFMOD_STUDIO_MEMORY_USAGE();
bus.getMemoryUsage(memusage);
GMFMOD_Check("Getting memory usage");
GMFMOD_Assert(instanceof(memusage) == "GMFMOD_STUDIO_MEMORY_USAGE", true,
    "memory usage output is the correct type");
GMFMOD_Assert(memusage.exclusive != -1, true, "Bus Get Memory Usage: exclusive");
GMFMOD_Assert(memusage.inclusive != -1, true, "Bus Get Memory Usage: inclusive");
GMFMOD_Assert(memusage.sampledata != -1, true, "Bus Get Memory Usage: sampledata");
delete memusage;

memusage = bus.getMemoryUsage();
GMFMOD_Check("Getting memory usage");
GMFMOD_Assert(instanceof(memusage) == "GMFMOD_STUDIO_MEMORY_USAGE", true,
    "memory usage output is the correct type");
GMFMOD_Assert(memusage.exclusive != -1, true, "Bus Get Memory Usage: exclusive");
GMFMOD_Assert(memusage.inclusive != -1, true, "Bus Get Memory Usage: inclusive");
GMFMOD_Assert(memusage.sampledata != -1, true, "Bus Get Memory Usage: sampledata");
delete memusage;


// ===== Get ID =====
var guid = new GMFMOD_GUID();
bus.getID(guid);
GMFMOD_Check("Getting ID");

GMFMOD_Assert(instanceof(guid) == "GMFMOD_GUID", true, 
    "ID retrieved is correct type");
GMFMOD_Assert(guid.data1, $3052120b, "Bus Get ID: data1");
GMFMOD_Assert(guid.data2, $9d99, "Bus Get ID: data2");
GMFMOD_Assert(guid.data3, $4272, "Bus Get ID: data3");
GMFMOD_Assert(guid.data4[0], $a2, "Bus Get ID: data4[0]");
GMFMOD_Assert(guid.data4[1], $00, "Bus Get ID: data4[1]");
GMFMOD_Assert(guid.data4[2], $2f, "Bus Get ID: data4[2]");
GMFMOD_Assert(guid.data4[3], $b5, "Bus Get ID: data4[3]");
GMFMOD_Assert(guid.data4[4], $bd, "Bus Get ID: data4[4]");
GMFMOD_Assert(guid.data4[5], $b5, "Bus Get ID: data4[5]");
GMFMOD_Assert(guid.data4[6], $66, "Bus Get ID: data4[6]");
GMFMOD_Assert(guid.data4[7], $d3, "Bus Get ID: data4[7]");
delete guid;

guid = bus.getID();
GMFMOD_Check("Getting ID");

GMFMOD_Assert(instanceof(guid) == "GMFMOD_GUID", true, 
    "ID retrieved is correct type");
GMFMOD_Assert(guid.data1, $3052120b, "Bus Get ID: data1");
GMFMOD_Assert(guid.data2, $9d99, "Bus Get ID: data2");
GMFMOD_Assert(guid.data3, $4272, "Bus Get ID: data3");
GMFMOD_Assert(guid.data4[0], $a2, "Bus Get ID: data4[0]");
GMFMOD_Assert(guid.data4[1], $00, "Bus Get ID: data4[1]");
GMFMOD_Assert(guid.data4[2], $2f, "Bus Get ID: data4[2]");
GMFMOD_Assert(guid.data4[3], $b5, "Bus Get ID: data4[3]");
GMFMOD_Assert(guid.data4[4], $bd, "Bus Get ID: data4[4]");
GMFMOD_Assert(guid.data4[5], $b5, "Bus Get ID: data4[5]");
GMFMOD_Assert(guid.data4[6], $66, "Bus Get ID: data4[6]");
GMFMOD_Assert(guid.data4[7], $d3, "Bus Get ID: data4[7]");
delete guid;


// ===== Get Path =====
GMFMOD_Assert(bus.getPath(), "bus:/", "Bus path matches");
GMFMOD_Check("Getting bus path");