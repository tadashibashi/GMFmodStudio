/// @struct                     GMFMS_ParamDesc([buf])
/// @param   {[GMFMS_Buffer]}   [buf:GMFMS_Buffer] (optional) buffer to initialize this object from 
/// @returns {GMFMS_ParamDesc}
///
function GMFMS_ParamDesc() constructor
{
	/// @description     A GML representation of the FMOD_STUDIO_PARAMETER_DESCRIPTION object.
	///                  Contains helper functions to manage buffer transfer to and from the 
	///                  GMFmodStudio extension.
	///
	
	// ===== Initialization ======================================================
	// Name of this parameter
	name =         "";                  /// @is {string}
	
	// FMOD_STUDIO_PARAMETER_ID, use this to access parameter get/set by id
	pid =          new GMFMS_ParamID(); /// @is {GMFMS_ParamID}
	
	// Minimum value this parameter can be set to.
	minimum =      0;                   /// @is {number}
	
	// Maximum value this parameter can be set to.
	maximum =      0;                   /// @is {number}
	
	// Default value this parameter is set to.
	defaultvalue = 0;                   /// @is {number}
	
	// The FMOD_STUIO_PARAMETER_TYPE.
	type =         0;                   /// @is {int}
	
	// The FMOD_STUDIO_PARAMTER_FLAGS properties.
	flags =        0;                   /// @is {int}
	
	// ---------------------------------------------------------------------------
	
	/// @function                 readFromBuffer(buf: GMFMS_Buffer)->void
	/// @param    {GMFMS_Buffer}  buf Buffer to retrieve assignment data from.
	/// @returns  {void}
	static readFromBuffer = function(buf/*: GMFMS_Buffer*/)
	{
		/// @description   Reads data from a buffer and assigns it to this struct.
		///
		
		name = buf.readCharStar();
		pid.readFromBuffer(buf);
		minimum = buf.read(buffer_f32);
		maximum = buf.read(buffer_f32);
		defaultvalue = buf.read(buffer_f32);
		type = buf.read(buffer_u32);
		flags = buf.read(buffer_u32);
	};
	
	// Optional initialization via buffer.
	if (argument_count == 1 && instanceof(argument[0]) == "GMFMS_Buffer")
	{
		readFromBuffer(argument[0]);	
	}
	
	/// @function        log()->void
	/// @returns {void}
	static log = function()
	{
		/// @description   Logs a debug message with this ParameterDescription's data.
		///
		
		show_debug_message("===== GMFMS_ParamDesc Log =====");
		show_debug_message("name: " + name);
		show_debug_message("id: " + string(pid.data1) + ", " + string(pid.data2));
		show_debug_message("minimum: " + string(minimum));
		show_debug_message("maximum: " + string(maximum));
		show_debug_message("defaultvalue: " + string(defaultvalue));
		show_debug_message("type: " + string(type));
		show_debug_message("flags: " + string(flags));
	};
	
	// no need for a writeToBuffer, since this is readonly user information
}

// GMEdit Hints ===============================================================
/// @hint new GMFMS_ParamDesc([buf:GMFMS_Buffer])->GMFMS_ParamDesc
/// @hint GMFMS_ParamDesc:readFromBuffer(buf: GMFMS_Buffer)->void Fill this object with info retrieved from a buffer.
/// @hint GMFMS_ParamDesc:log()->void Log the data from this parameter description to the console.

