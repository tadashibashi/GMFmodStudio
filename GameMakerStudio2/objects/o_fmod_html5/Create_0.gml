/// @description Insert description here
// You can write your code in this editor

studio = GMFMOD_Ptr(fmod_studio_system_create());

var buf = GMFMOD_GetBuffer();
fmod_studio_system_get_advanced_settings(studio, buf.getAddress());

var advsettings = new GMFMOD_STUDIO_ADVANCED_SETTINGS(buf);

GMFMOD_Assert(
	GMFMOD_GetError(), FMOD_OK,
	"StudioSystem Get Advanced Settings: No errors");
GMFMOD_Assert(
	advsettings.commandqueuesize, 32768,
	"StudioSystem Get Advanced Settings: commandqueuesize");
GMFMOD_Assert(
	advsettings.idlesampledatapoolsize, 262144,
	"StudioSystem Get Advanced Settings: idlesampledatapoolsize");
GMFMOD_Assert(
	advsettings.streamingscheduledelay, 8192,
	"StudioSystem Get Advanced Settings: streamingscheduledelay");
GMFMOD_Assert(
	advsettings.encryptionkey, "",
	"StudioSystem Get Advanced Settings: encryptionkey");

buf.seekReset();
advsettings.encryptionkey = "encryptionkey";
advsettings.writeToBuffer(buf);

fmod_studio_system_set_advanced_settings(studio, buf.getAddress());
GMFMOD_Assert(
	GMFMOD_GetError(), FMOD_OK,
	"StudioSystem Set Advanced Settings");


fmod_studio_system_initialize(studio, 128, FMOD_STUDIO_INIT_NORMAL, FMOD_INIT_NORMAL);

fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL);
fmod_studio_system_load_bank_file(studio, 
	working_directory + "soundbanks/Desktop/Master_ENG.strings.bank",
	FMOD_STUDIO_LOAD_BANK_NORMAL);
	
evdesc = GMFMOD_Ptr(fmod_studio_system_get_event(studio, "event:/Music"));
GMFMOD_Check("getting event description");
evinst = GMFMOD_Ptr(fmod_studio_evdesc_create_instance(evdesc));

fmod_studio_evinst_start(evinst);
