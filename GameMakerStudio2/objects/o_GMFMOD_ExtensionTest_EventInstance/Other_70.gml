/// @description Insert description here
// You can write your code in this editor
var map = async_load;

if (map[?"fmodCallbackType"] == "EventInstance")
{
	if (map[?"type"] == FMOD_STUDIO_EVENT_CALLBACK_TIMELINE_BEAT)
	{
		var inst = GMFMOD_Ptr(map[?"inst"]);
		GMFMOD_Assert(is_numeric(map[?"beat"]), true, "EvInst Set Callback: Timeline Beat");
		GMFMOD_Assert(fmod_studio_evinst_is_valid(inst), true, 
			"EvDesc Set Callback: Timeline Beat valid instance");
		
		fmod_studio_evinst_stop(inst, FMOD_STUDIO_STOP_IMMEDIATE);
		fmod_studio_evinst_release(inst);
	}
}