/// @description Insert description here
// You can write your code in this editor
var map = async_load;


if (map[?"fmodCallbackType"] == "StudioSystem")
{
	GMFMOD_Assert(
		map[?"type"],
		FMOD_STUDIO_SYSTEM_CALLBACK_PREUPDATE,
		"StudioSystem Callback: type");
}
