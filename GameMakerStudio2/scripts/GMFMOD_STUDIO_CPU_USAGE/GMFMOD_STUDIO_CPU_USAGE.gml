/// @file Info for a single buffer in FMOD Studio. 
/// Implementation of the FMOD_STUDIO_CPU_USAGE object.
/// @copyright Aaron Ishibashi, 2021.

/// @struct GMFMOD_STUDIO_CPU_USAGE([buf: GMFMOD_Buffer])
/// @param {GMFMOD_Buffer} [buf] (optional) Buffer from which to initialize this
/// struct from.
function GMFMOD_STUDIO_CPU_USAGE() constructor
{
	dspusage =      -1;  /// @is {number} float
	streamusage =   -1;  /// @is {number} float
	geometryusage = -1;  /// @is {number} float
	updateusage =   -1;  /// @is {number} float
	studiousage =   -1;  /// @is {number} float
	
	/// @func readFromBuffer(buf: GMFMOD_Buffer)->void
	/// @desc Populates this object with the contents from a buffer.
	/// @returns {void}
	static readFromBuffer = function(buf/*: GMFMOD_Buffer*/)
	{
		dspusage =      buf.read(buffer_f32);
		streamusage =   buf.read(buffer_f32);
		geometryusage = buf.read(buffer_f32);
		updateusage =   buf.read(buffer_f32);
		studiousage =   buf.read(buffer_f32);
	};
	
	if (argument_count == 1 && instanceof(argument[0]) == "GMFMOD_Buffer")
	{
		readFromBuffer(argument[0]);	
	}
	
	/// @func                    writeToBuffer(buf: GMFMOD_Buffer)->void
	/// @param   {GMFMOD_Buffer}  buf The buffer to write to.
	/// @returns {void}
	static writeToBuffer = function(buf/*: GMFMOD_Buffer*/)
	{
		/// @description     Writes this object's internal data to a buffer.
		///
		buf.write(buffer_f32, dspusage);
		buf.write(buffer_f32, streamusage);
		buf.write(buffer_f32, geometryusage);
		buf.write(buffer_f32, updateusage);
		buf.write(buffer_f32, studiousage);
	};
	
	/// @func           log()->void
	/// @returns {void}
	static log = function()
	{
		/// @description    Logs this object's internal data to the console.
		///
		show_debug_message("===== GMFMOD_STUDIO_CPU_USAGE Log =====");	
		show_debug_message("dspusage: " + string(dspusage));	
		show_debug_message("streamusage: " + string(streamusage));	
		show_debug_message("geometryusage: " + string(geometryusage));	
		show_debug_message("updateusage: " + string(updateusage));	
		show_debug_message("studiousage: " + string(studiousage));	
	};
}

// GMEdit Hints ===============================================================
/// @hint GMFMOD_STUDIO_CPU_USAGE:readFromBuffer(buf: GMFMOD_Buffer)->void Reads data from a buffer and assigns it to this struct.
/// @hint GMFMOD_STUDIO_CPU_USAGE:writeToBuffer(buf: GMFMOD_Buffer)->void Writes data from this struct into a buffer.
/// @hint GMFMOD_STUDIO_CPU_USAGE:log()->void Logs data from this struct to the console.
