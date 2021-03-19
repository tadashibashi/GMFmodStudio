/// @description Insert description here
// You can write your code in this editor
var map = async_load;

if (map[?"fmodCallbackType"] == "EventInstance")
{
	switch(map[?"type"])
	{
		case FMOD_STUDIO_EVENT_CALLBACK_STARTED:
			show_debug_message("Event Started!");
		break;
		
		case FMOD_STUDIO_EVENT_CALLBACK_STOPPED:
			show_debug_message("Event Stopped!");
		break;
	}
}