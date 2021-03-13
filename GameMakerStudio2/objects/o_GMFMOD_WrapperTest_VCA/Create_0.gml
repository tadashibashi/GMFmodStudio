/// @description VCA General Tests

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

vca = studio.getVCA("vca:/TestVCA"); /// @is {GMFMOD_Studio_VCA}
GMFMOD_Check("Getting VCA");
GMFMOD_Assert(vca.isValid(), true, "Retrieved valid VCA");



// ===== Set/Get Volume =====
GMFMOD_Assert(vca.getVolume(), 1, "VCA volume starts at 1");
GMFMOD_Check("Getting VCA volume");

vca.setVolume(3);
GMFMOD_Check("Setting volume");

studio.flushCommands();
GMFMOD_Check("Flushing commands");

show_debug_message("VCA:getVolumeFinal always returns 1, may be an FMOD bug");

GMFMOD_Assert(vca.getVolumeFinal(), 1, "VCA volume final is 1");
GMFMOD_Check("Getting final volume");

// ===== Get ID =====
var guid = new GMFMOD_GUID();
vca.getID(guid);
GMFMOD_Check("Getting ID");

GMFMOD_Assert(instanceof(guid) == "GMFMOD_GUID", true, "GUID is correct type");
GMFMOD_Assert(guid.data1, $498278ec, "Vca Get ID: data1");
GMFMOD_Assert(guid.data2, $60ce, "Vca Get ID: data2");
GMFMOD_Assert(guid.data3, $42c9, "Vca Get ID: data3");
GMFMOD_Assert(guid.data4[0], $ad, "Vca Get ID: data4[0]");
GMFMOD_Assert(guid.data4[1], $6d, "Vca Get ID: data4[1]");
GMFMOD_Assert(guid.data4[2], $96, "Vca Get ID: data4[2]");
GMFMOD_Assert(guid.data4[3], $97, "Vca Get ID: data4[3]");
GMFMOD_Assert(guid.data4[4], $f5, "Vca Get ID: data4[4]");
GMFMOD_Assert(guid.data4[5], $b9, "Vca Get ID: data4[5]");
GMFMOD_Assert(guid.data4[6], $08, "Vca Get ID: data4[6]");
GMFMOD_Assert(guid.data4[7], $40, "Vca Get ID: data4[7]");
delete guid;

guid = vca.getID();
GMFMOD_Check("Getting ID");

GMFMOD_Assert(instanceof(guid) == "GMFMOD_GUID", true, "GUID is correct type");
GMFMOD_Assert(guid.data1, $498278ec, "Vca Get ID: data1");
GMFMOD_Assert(guid.data2, $60ce, "Vca Get ID: data2");
GMFMOD_Assert(guid.data3, $42c9, "Vca Get ID: data3");
GMFMOD_Assert(guid.data4[0], $ad, "Vca Get ID: data4[0]");
GMFMOD_Assert(guid.data4[1], $6d, "Vca Get ID: data4[1]");
GMFMOD_Assert(guid.data4[2], $96, "Vca Get ID: data4[2]");
GMFMOD_Assert(guid.data4[3], $97, "Vca Get ID: data4[3]");
GMFMOD_Assert(guid.data4[4], $f5, "Vca Get ID: data4[4]");
GMFMOD_Assert(guid.data4[5], $b9, "Vca Get ID: data4[5]");
GMFMOD_Assert(guid.data4[6], $08, "Vca Get ID: data4[6]");
GMFMOD_Assert(guid.data4[7], $40, "Vca Get ID: data4[7]");
delete guid;

// ===== Get Path =====
GMFMOD_Assert(vca.getPath(), "vca:/TestVCA", "VCA get path: matches");
GMFMOD_Check("Getting path");