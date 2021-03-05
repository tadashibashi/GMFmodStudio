// Create and initialize the FMOD Studio System for testing
checkedupdate = false;

perf = new GMFMOD_Performance();
studio = GMFMOD_Ptr(fmod_studio_system_create());

GMFMS_Assert(fmod_studio_system_is_valid(studio), true, "Studio System Create");

// ----------------------------------------------------------------------------
// StudioSystem Set/Get Advanced Settings
// functions: 
//    fmod_studio_system_get_advanced_settings
//    fmod_studio_system_set_advanced_settings
// ----------------------------------------------------------------------------
var buf = GMFMOD_GetBuffer();
fmod_studio_system_get_advanced_settings(studio, buf.getAddress());

var advsettings = new GMFMOD_STUDIO_ADVANCED_SETTINGS(buf);

GMFMS_Assert(
	GMFMOD_GetError(), FMOD_OK,
	"StudioSystem Get Advanced Settings: No errors");
GMFMS_Assert(
	advsettings.commandqueuesize, 32768,
	"StudioSystem Get Advanced Settings: commandqueuesize");
GMFMS_Assert(
	advsettings.idlesampledatapoolsize, 262144,
	"StudioSystem Get Advanced Settings: idlesampledatapoolsize");
GMFMS_Assert(
	advsettings.streamingscheduledelay, 8192,
	"StudioSystem Get Advanced Settings: streamingscheduledelay");
GMFMS_Assert(
	advsettings.encryptionkey, "",
	"StudioSystem Get Advanced Settings: encryptionkey");

buf.seekReset();
advsettings.encryptionkey = "encryptionkey";
advsettings.writeToBuffer(buf);

fmod_studio_system_set_advanced_settings(studio, buf.getAddress());
GMFMS_Assert(
	GMFMOD_GetError(), FMOD_OK,
	"StudioSystem Set Advanced Settings");

fmod_studio_system_initialize(
	studio, 
	1024, 
	FMOD_STUDIO_INIT_LIVEUPDATE, 
	FMOD_INIT_PROFILE_ENABLE);
	
GMFMS_Assert(GMFMOD_GetError(), FMOD_OK, "Studio System Initialize");

onFinish = [];

/// @func finish()
function finish()
{
	var len = array_length(onFinish);
	for (var i = 0; i < len; ++i)
	{
		onFinish[i](self);	
	}
}

/// @func addFinishListener
/// @param func callback function with one parameter for object index.
function addFinishListener(func)
{
	array_push(onFinish, func);	
}