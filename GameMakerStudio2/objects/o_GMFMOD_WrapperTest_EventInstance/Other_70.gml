
var map = async_load;

if (map[?"fmodCallbackType"] == "EventInstance")
{
	if (map[?"type"] == FMOD_STUDIO_EVENT_CALLBACK_TIMELINE_BEAT)
	{
		GMFMOD_Assert(is_numeric(map[?"beat"]), true, "EvInst Set Callback: Timeline Beat");
		
	}
}

