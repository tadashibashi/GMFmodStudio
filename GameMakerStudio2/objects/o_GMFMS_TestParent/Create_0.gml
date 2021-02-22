// Create and initialize the FMOD Studio System for testing
studio = ptr(fmod_studio_system_create());

check = fmod_studio_system_initialize(
	studio, 
	1024, 
	FMOD_STUDIO_INIT_NORMAL, 
	FMOD_INIT_NORMAL);
	
if (check != 0)
	throw "FMOD Studio Initialization Error: " + GMFMS_GetErrorString();


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