/// @description Insert description here
// You can write your code in this editor
var map = async_load;

if (map[?"fmodCallbackType"] == "EventInstance")
{
	switch(map[?"type"])
	{
		case FMOD_STUDIO_EVENT_CALLBACK_CREATE_PROGRAMMER_SOUND:
			show_debug_message("Programmer Sound Created!");
			show_debug_message(map[?"event"]);
		break;
		
		case FMOD_STUDIO_EVENT_CALLBACK_DESTROY_PROGRAMMER_SOUND:
			show_debug_message("Programmer Sound Destroyed!");
			show_debug_message(map[?"event"]);
		break;
	}
}