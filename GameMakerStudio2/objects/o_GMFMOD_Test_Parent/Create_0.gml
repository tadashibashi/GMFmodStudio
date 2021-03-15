// Create and initialize the FMOD Studio System for testing


perf = new GMFMOD_Performance();

onFinish = [];

/// @func finish()
function finish()
{
	var len = array_length(onFinish);
	for (var i = 0; i < len; ++i)
	{
		array_get(onFinish, i)(self);
	}
}


/// @param func callback function with one parameter for object index.
function addFinishListener(func)
{
	array_push(onFinish, func);
}

