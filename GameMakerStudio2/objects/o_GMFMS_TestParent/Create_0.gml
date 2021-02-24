// Create and initialize the FMOD Studio System for testing
checkedupdate = false;

studio = ptr(fmod_studio_system_create());

GMFMS_Assert(fmod_studio_system_is_valid(studio), true, "Studio System Create");

fmod_studio_system_initialize(
	studio, 
	1024, 
	FMOD_STUDIO_INIT_NORMAL, 
	FMOD_INIT_NORMAL);
	
GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "Studio System Initialize");

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