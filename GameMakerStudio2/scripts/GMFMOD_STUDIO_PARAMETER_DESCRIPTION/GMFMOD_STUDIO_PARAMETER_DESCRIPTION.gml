/// @struct  GMFMOD_STUDIO_PARAMETER_DESCRIPTION([buf])
/// @param   {[GMFMOD_Buffer]}   [buf:GMFMOD_Buffer] (optional) buffer to initialize this object from 
/// @returns {GMFMOD_STUDIO_PARAMETER_DESCRIPTION}
///
function GMFMOD_STUDIO_PARAMETER_DESCRIPTION() constructor
{
	/// @description     A GML representation of the FMOD_STUDIO_PARAMETER_DESCRIPTION object.
	///                  Contains helper functions to manage buffer transfer to and from the 
	///                  GMFmodStudio extension.
	///
	
	// ===== Initialization ======================================================
	// Name of this parameter
	name =         "";                  /// @is {string}
	
	// FMOD_STUDIO_PARAMETER_ID, use this to access parameter get/set by id
	pid =          new GMFMOD_STUDIO_PARAMETER_ID(); /// @is {GMFMOD_STUDIO_PARAMETER_ID}
	
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
	
	/// @function                 readFromBuffer(buf: GMFMOD_Buffer)->void
	/// @param    {GMFMOD_Buffer}  buf Buffer to retrieve assignment data from.
	/// @returns  {void}
	static readFromBuffer = function(buf/*: GMFMOD_Buffer*/)
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
	if (argument_count == 1 && instanceof(argument[0]) == "GMFMOD_Buffer")
	{
		readFromBuffer(argument[0]);	
	}
	
	/// @function        log()->void
	/// @returns {void}
	static log = function()
	{
		/// @description   Logs a debug message with this ParameterDescription's data.
		///
		
		show_debug_message("===== GMFMOD_STUDIO_PARAMETER_DESCRIPTION Log =====");
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
/// @hint new GMFMOD_STUDIO_PARAMETER_DESCRIPTION([buf:GMFMOD_Buffer])->GMFMOD_STUDIO_PARAMETER_DESCRIPTION
/// @hint GMFMOD_STUDIO_PARAMETER_DESCRIPTION:readFromBuffer(buf: GMFMOD_Buffer)->void Fill this object with info retrieved from a buffer.
/// @hint GMFMOD_STUDIO_PARAMETER_DESCRIPTION:log()->void Log the data from this parameter description to the console.

