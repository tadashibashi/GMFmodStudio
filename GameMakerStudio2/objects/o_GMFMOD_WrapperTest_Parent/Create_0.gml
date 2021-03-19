// Inherit the parent event
event_inherited();

// Initialize FMOD Stduio
checkedupdate = false;               /// @is {bool}
studio = new GMFMOD_Studio_System(); /// @is {GMFMOD_Studio_System}

GMFMOD_Assert(studio.isValid(), true, "StudioSystem is valid");

if (typeof(studio.studio_) != "struct")
{
	// Set/Get Advanced Settings
	var advsettings1/*: GMFMOD_STUDIO_ADVANCED_SETTINGS*/ = 
	    new GMFMOD_STUDIO_ADVANCED_SETTINGS();
	studio.getAdvancedSettings(advsettings1);

	GMFMOD_Check("StudioSystem Getting Advanced Settings");

	var advsettings2/*: GMFMOD_STUDIO_ADVANCED_SETTINGS*/ = studio.getAdvancedSettings();

	GMFMOD_Assert(
		advsettings1.commandqueuesize, 32768,
		"StudioSystem Get Advanced Settings: commandqueuesize");
	GMFMOD_Assert(
		advsettings1.idlesampledatapoolsize, 262144,
		"StudioSystem Get Advanced Settings: idlesampledatapoolsize");
	GMFMOD_Assert(
		advsettings1.streamingscheduledelay, 8192,
		"StudioSystem Get Advanced Settings: streamingscheduledelay");
	GMFMOD_Assert(
		advsettings1.encryptionkey, "",
		"StudioSystem Get Advanced Settings: encryptionkey");

	GMFMOD_Assert(
		advsettings2.commandqueuesize, 32768,
		"StudioSystem Get Advanced Settings: commandqueuesize");
	GMFMOD_Assert(
		advsettings2.idlesampledatapoolsize, 262144,
		"StudioSystem Get Advanced Settings: idlesampledatapoolsize");
	GMFMOD_Assert(
		advsettings2.streamingscheduledelay, 8192,
		"StudioSystem Get Advanced Settings: streamingscheduledelay");
	GMFMOD_Assert(
		advsettings2.encryptionkey, "",
		"StudioSystem Get Advanced Settings: encryptionkey");

	advsettings1.encryptionkey = "encryptionkey";
	studio.setAdvancedSettings(advsettings1);

	GMFMOD_Check("StudioSystem Setting Advanced Settings");

	delete advsettings1;
	delete advsettings2;
}

studio.initialize(1024, FMOD_STUDIO_INIT_LIVEUPDATE, FMOD_INIT_PROFILE_ENABLE);
GMFMOD_Check("Initializing Studio System");
