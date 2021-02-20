/// @description Insert description here
// You can write your code in this editor
var dsmap = async_load;

if (dsmap[?"testVal"] == "Hello World!")
	show_debug_message("Success!!!");


if (dsmap[?"fmod"] != undefined)
{
	if (dsmap[?"type"] == FMOD_STUDIO_EVENT_CALLBACK_TIMELINE_BEAT)
	{
		show_debug_message("==Timeline Beat==");
		show_debug_message("bar: " + string(dsmap[?"bar"]));
		show_debug_message("beat: " + string(dsmap[?"beat"]));
	}

	if (dsmap[?"type"] == FMOD_STUDIO_EVENT_CALLBACK_TIMELINE_MARKER)
	{
		show_debug_message("==Timeline Marker==");
		show_debug_message("name: " + dsmap[?"name"]);
		show_debug_message("position: " + string(dsmap[?"position"]));
	}
}
