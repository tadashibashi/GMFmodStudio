/// @file A GML representation of the FMOD_STUDIO_PARAMETER_ID struct.
/// Contains helper functions to manage buffer transfer to and from the 
/// GMFmodStudio extension.
/// @copyright Aaron Ishibashi, 2021.

/// @struct GMFMOD_STUDIO_PARAMETER_ID([buf: GMFMOD_Buffer])
/// @param {GMFMOD_Buffer} [buf]
///

function GMFMOD_STUDIO_PARAMETER_ID() constructor
{
	// ===== Initialization ======================================================
	
	data1 = 0; /// @is {int} First data value of id
	data2 = 0; /// @is {int} Second data value of id
	// ---------------------------------------------------------------------------
	
	/// @func readFromBuffer(buf: GMFMOD_Buffer)->void
	/// @param {GMFMOD_Buffer} buf
	///
	/// @desc Reads data from buffer and assigns it to struct.
	static readFromBuffer = function(buf)
	{
		data1 = buf.read(buffer_u32);
		data2 = buf.read(buffer_u32);
	};
	
	if (argument_count == 1 && instanceof(argument[0]) == "GMFMOD_Buffer")
	{
		readFromBuffer(argument[0]);	
	}
	
	/// @func writeToBuffer(buf: GMFMOD_Buffer)->void
	/// @param {GMFMOD_Buffer} buf
	///
	/// @desc Writes struct data into a buffer.
	static writeToBuffer = function(buf)
	{
		buf.write(buffer_u32, data1);
		buf.write(buffer_u32, data2);
	};
	
	/// @func log()->void
	///
	/// @desc Logs the data from this struct to the console.
	static log = function()
	{
		show_debug_message("===== GMFMOD_STUDIO_PARAMETER_ID Log =====");
		show_debug_message("data1: " + string(data1));
		show_debug_message("data2: " + string(data2));
	};
}

// GMEdit Hints ===============================================================
/// @hint GMFMOD_STUDIO_PARAMETER_ID:readFromBuffer(buf: GMFMOD_Buffer)->void Reads data from buffer and assigns it to this struct.
/// @hint GMFMOD_STUDIO_PARAMETER_ID:writeToBuffer(buf: GMFMOD_Buffer)->void Writes struct data into a buffer.
/// @hint GMFMOD_STUDIO_PARAMETER_ID:log()->void Log struct data to the console.
