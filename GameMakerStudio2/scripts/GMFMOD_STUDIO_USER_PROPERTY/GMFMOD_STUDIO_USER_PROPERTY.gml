/// @file A GML representation of the FMOD_STUDIO_USER_PROPERTY struct.
/// Contains helper functions to manage buffer transfer to and from the 
/// GMFmodStudio extension.
/// An FMOD Studio user property is an arbitrary property contained by an 
/// EventDescription authored in the FMOD Studio application.
/// Although there are 4 types of properties, only Float and String are
/// currently supported by FMOD Studio itself.
/// @copyright Aaron Ishibashi, 2021.

/// @struct GMFMOD_STUDIO_USER_PROPERTY([buffer: GMFMOD_Buffer])
/// @param {GMFMOD_Buffer} [buffer] (optional) initialization via buffer
///
function GMFMOD_STUDIO_USER_PROPERTY() constructor
{
	// ===== Initialization ======================================================
	
	name = ""; /// @is {string}
	type = 0;  /// @is {int}
	value = 0; /// @is {number|string}
	// ---------------------------------------------------------------------------
	
	/// @func readFromBuffer(buf: GMFMOD_Buffer)->void
	/// @param {GMFMOD_Buffer} buf
	///
	/// @desc Read data from a buffer and assign it to this user property.
	static readFromBuffer = function(buf)
	{
		self.name = buf.readCharStar();
		self.type = buf.read(buffer_u32);
		switch(type)
		{
			case FMOD_STUDIO_USER_PROPERTY_TYPE_BOOLEAN:
				self.value = buf.read(buffer_s8);
				break;
			case FMOD_STUDIO_USER_PROPERTY_TYPE_FLOAT:
				self.value = buf.read(buffer_f32);
				break;
			case FMOD_STUDIO_USER_PROPERTY_TYPE_INTEGER:
				self.value = buf.read(buffer_s32);
				break;
			case FMOD_STUDIO_USER_PROPERTY_TYPE_STRING:
				self.value = buf.readCharStar();
				break;
			default: // error here?
				break;
		}
	};
	
	// Optional initialization by GMFMS buffer object
	if (argument_count == 1 && instanceof(argument[0]) == "GMFMOD_Buffer")
	{
		readFromBuffer(argument[0]);
	}
	
	/// @func getTypeAsString()->string
	///
	/// @desc Helper returns the type name of the value as a string.
	static getTypeAsString = function()
	{
		switch(type)
		{
			case FMOD_STUDIO_USER_PROPERTY_TYPE_BOOLEAN:
				return "Boolean"
			case FMOD_STUDIO_USER_PROPERTY_TYPE_FLOAT:
				return "Float";
			case FMOD_STUDIO_USER_PROPERTY_TYPE_INTEGER:
				return "Integer";
			case FMOD_STUDIO_USER_PROPERTY_TYPE_STRING:
				return "String";
			default: // error here?
				return "Unknown";
		}
	};
	
	/// @func log()->void
	///
	/// @desc Helper function: logs internal data to the console.
	static log = function()
	{
		show_debug_message("===== FmodStudioProperty Log =====");	
		show_debug_message("name: " + name);	
		show_debug_message("type: " + getTypeAsString());
		show_debug_message("value: " + string(value));	
	};
}

// GMEdit Hints ===============================================================
/// @hint GMFMOD_STUDIO_USER_PROPERTY:readFromBuffer(buf: GMFMOD_Buffer)->void Propogate this object from a filled buffer
/// @hint GMFMOD_STUDIO_USER_PROPERTY:getTypeAsString()->string Get the type name of the value as a string.
/// @hint GMFMOD_STUDIO_USER_PROPERTY:log()->void Log the data within this UserProperty to the console.
