
var map = async_load;

if (checkedupdate == false)
{
	if (map[?"fmodCallbackType"] == "StudioSystem")
	{
		GMFMOD_Assert(
			map[?"type"],
			FMOD_STUDIO_SYSTEM_CALLBACK_PREUPDATE,
			"StudioSystem Callback: type");
		checkedupdate = true;
	}
}