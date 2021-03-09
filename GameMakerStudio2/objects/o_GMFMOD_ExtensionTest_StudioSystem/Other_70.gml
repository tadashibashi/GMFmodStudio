/// @description Insert description here
// You can write your code in this editor
var map = async_load;

if (checkedupdate == false)
{
	if (map[?"fmodCallbackType"] == "StudioSystem")
	{
		GMFMOD_Assert(
			fmod_studio_system_is_valid(GMFMOD_Ptr(map[?"system"])),
			true,
			"StudioSystem Callback: system");
		GMFMOD_Assert(
			map[?"type"],
			FMOD_STUDIO_SYSTEM_CALLBACK_PREUPDATE,
			"StudioSystem Callback: type");
	}
}
