/// @file Info for a single buffer in FMOD Studio. Implementation of the 
/// FMOD_STUDIO_BUFFER_INFO object.
/// @copyright Aaron Ishibashi, 2021.

/// @struct GMFMS_BufInfo([buf]: GMFMS_Buffer)
/// @param {GMFMS_Buffer} [buf] (optional) Buffer to initialize data from.
///
function GMFMS_BufInfo() constructor
{
	currentusage = -1;  /// @is {int} int_32_t
	peakusage =    -1;  /// @is {int} int_32_t
	capacity =     -1;  /// @is {int} int_32_t
	stallcount =   -1;  /// @is {int} int_32_t
	stalltime =    -1;  /// @is {number} float 32
	
	/// @func readFromBuffer(buf: GMFMS_Buffer)
	/// @desc Populates this object with the contents form a buffer.
	/// @returns {void}
	static readFromBuffer = function(buf)
	{
		currentusage = buf.read(buffer_s32);
		peakusage    = buf.read(buffer_s32);
		capacity     = buf.read(buffer_s32);
		stallcount   = buf.read(buffer_s32);
		stalltime    = buf.read(buffer_f32);
	};
	
	// Optional buffer initialization.
	if (argument_count == 1 && instanceof(argument[0]) == "GMFMS_Buffer")
	{
		readFromBuffer(argument[0]);	
	}
	
	/// @func writeToBuffer(buf: GMFMS_Buffer)
	/// @desc Writes this object's internal data to a buffer.
	/// @returns {void}
	static writeToBuffer = function(buf)
	{
		buf.write(buffer_s32, currentusage);
		buf.write(buffer_s32, peakusage);
		buf.write(buffer_s32, capacity);
		buf.write(buffer_s32, stallcount);
		buf.write(buffer_f32, stalltime);
	};
	
	/// @function log()
	/// @description Logs this object's internal data to the console.
	/// @returns {void}
	static log = function()
	{
		show_debug_message("===== GMFMS_BufInfo Log =====");	
		show_debug_message("currentusage: " + string(currentusage));	
		show_debug_message("peakusage: " + string(peakusage));	
		show_debug_message("capacity: " + string(capacity));	
		show_debug_message("stallcount: " + string(stallcount));	
		show_debug_message("stalltime: " + string(stalltime));	
	};
}

// GMEdit Hints ===============================================================
/// @hint GMFMS_BufInfo:readFromBuffer(buf: GMFMS_Buffer)->void Reads data from a buffer and assigns it to this struct.
/// @hint GMFMS_BufInfo:writeToBuffer(buf: GMFMS_Buffer)->void Writes this object's data into a buffer.
/// @hint GMFMS_BufInfo:log()->void Logs this object's internal data to the console.
