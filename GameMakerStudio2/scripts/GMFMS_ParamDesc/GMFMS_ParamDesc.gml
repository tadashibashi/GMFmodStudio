

function GMFMS_ParamDesc() constructor
{
	// Name of the parameter
	name = ""; /// @is {string}
	// FMOD_STUDIO_PARAMETER_ID. Can be used to access this parameter in the future.
	pid = new GMFMS_ParamID(); /// @is {GMFMS_ParamID}
	// Minimum value this parameter can be set to.
	minimum = 0; /// @is {number}
	// Maximum value this parameter can be set to.
	maximum = 0; /// @is {number}
	// Default value this parameter is set to.
	defaultvalue = 0; /// @is {number}
	// The FMOD_STUIO_PARAMETER_TYPE.
	type = 0; /// @is {number}
	// The FMOD_STUDIO_PARAMTER_FLAGS properties.
	flags = 0; /// @is {number}
	
	/// @func readFromBuffer()
	/// @param {GMFMS_Buffer} buf Buffer to retrieve assignment data from.
	/// @returns {void}
	static readFromBuffer = function(buf/*: GMFMS_Buffer*/)
	{
		name = buf.readCharStar();
		pid.readFromBuffer(buf);
		minimum = buf.read(buffer_f32);
		maximum = buf.read(buffer_f32);
		defaultvalue = buf.read(buffer_f32);
		type = buf.read(buffer_u32);
		flags = buf.read(buffer_u32);
	}
	
	/// @func log()
	/// @desc Logs a debug message with this ParameterDescription's data.
	/// @returns {void}
	static log = function()
	{
		show_debug_message("===== GMFMS_ParamDesc Log =====");
		show_debug_message("name: " + name);
		show_debug_message("id: " + string(pid.data1) + ", " + string(pid.data2));
		show_debug_message("minimum: " + string(minimum));
		show_debug_message("maximum: " + string(maximum));
		show_debug_message("defaultvalue: " + string(defaultvalue));
		show_debug_message("type: " + string(type));
		show_debug_message("flags: " + string(flags));
	}
	
	// no need for a writeToBuffer, since this is readonly user information
}

/// @hint GMFMS_ParamDesc:readFromBuffer(buf: GMFMS_Buffer)->void Fill this object with info retrieved from a buffer.
