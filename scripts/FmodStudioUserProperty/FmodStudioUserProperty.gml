
function FmodStudioUserProperty() constructor
{
	name = "";
	type = 0;
	value = 0;
	
	static assignFromBuffer = function(buf)
	{
		name = buf.readCharStar();
		type = buf.read(buffer_u32);
		switch(type)
		{
			case FMOD_STUDIO_USER_PROPERTY_TYPE_BOOLEAN:
				value = buf.read(buffer_s8);
				break;
			case FMOD_STUDIO_USER_PROPERTY_TYPE_FLOAT:
				value = buf.read(buffer_f32);
				break;
			case FMOD_STUDIO_USER_PROPERTY_TYPE_INTEGER:
				value = buf.read(buffer_s32);
				break;
			case FMOD_STUDIO_USER_PROPERTY_TYPE_STRING:
				value = buf.readCharStar();
				break;
			default: // error here?
				break;
		}
	};
	
	static log = function()
	{
		show_debug_message("===== FmodStudioProperty Log =====");	
		show_debug_message("name: " + name);	
		show_debug_message("type: " + string(type));
		show_debug_message("value: " + string(value));	
	};
}

/// @hint FmodStudioUserProperty:assignFromBuffer(buf: FmodBuffer)->void Propogate this object from a filled buffer
/// @hint FmodStudioUserProperty:log()->void Log the data within this UserProperty to the console.
