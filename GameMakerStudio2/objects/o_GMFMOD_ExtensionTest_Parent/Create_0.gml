// Create and initialize the FMOD Studio System for testing
event_inherited();

checkedupdate = false;
studio = GMFMOD_Ptr(fmod_studio_system_create());

GMFMOD_Assert(fmod_studio_system_is_valid(studio), true, "Studio System Create");

// ----------------------------------------------------------------------------
// StudioSystem Set/Get Advanced Settings
// functions: 
//    fmod_studio_system_get_advanced_settings
//    fmod_studio_system_set_advanced_settings
// ----------------------------------------------------------------------------
if (typeof(studio) != "struct")
{
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
}


fmod_studio_system_initialize(
	studio, 
	1024, 
	FMOD_STUDIO_INIT_LIVEUPDATE, 
	FMOD_INIT_PROFILE_ENABLE);
	
GMFMOD_Assert(GMFMOD_GetError(), FMOD_OK, "Studio System Initialize");
