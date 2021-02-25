/// @file A GML representation of the FMOD_STUDIO_MEMORY_USAGE struct.
/// Contains helper functions to manage buffer transfer to and from the 
/// GMFmodStudio extension.
/// @copyright Aaron Ishibashi, 2021.

/// @struct GMFMS_MemUsage([buffer: GMFMS_Buffer])
/// @param {GMFMS_Buffer} [buffer]
///
function GMFMS_MemUsage() constructor
{
	// ===== Initialization ======================================================
	
	exclusive = -1;  /// @is {int} Size of memory belonging to the bus or event instance.
	inclusive = -1;  /// @is {int} Size of memory belonging exclusively to the bus or event plus inclusive memory sizes of all buses and event instances which route into it.
	sampledata = -1; /// @is {int} Size of shared sample memory referenced by the bus or event instance, inclusive of all sample memory referenced by all buses and event instances which route into it.
	// ---------------------------------------------------------------------------
	
	
	/// @func readFromBuffer(buf: GMFMS_Buffer)->void
	/// @param {GMFMS_Buffer} buf
	///
	/// @desc Read data from a buffer and assign it to this struct.
	static readFromBuffer = function(buf)
	{
		exclusive = buf.read(buffer_s32);
		inclusive = buf.read(buffer_s32);
		sampledata = buf.read(buffer_s32);
	}
	
	// Optional initialization via buffer
	if (argument_count == 1 && instanceof(argument[0]) == "GMFMS_Buffer")
	{
		readFromBuffer(argument[0]);	
	}
	
	
	/// @func log()->void
	///
	/// @desc Log data from this struct to the console.
	static log = function()
	{
		show_debug_message("===== GMFMS_MemUsage Log =====");
		show_debug_message("exclusive: " + string(exclusive));
		show_debug_message("inclusive: " + string(inclusive));
		show_debug_message("sampledata: " + string(sampledata));
	}
}

// GMEdit Hints ===============================================================
/// @hint GMFMS_MemUsage:readFromBuffer(buf: GMFMS_Buffer)->void Read data from a buffer and assign it to the struct.
/// @hint GMFMS_MemUsage:log()->void Log struct data to the console.