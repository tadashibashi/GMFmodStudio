/// @file A GML representation of the FMOD_VECTOR struct.
/// Contains helper functions to manage buffer transfer to and from the 
/// GMFmodStudio extension.
/// 0 arguments initializes the vector at position: {0, 0, 0}
/// 1 GMFMOD_Buffer object initializes the vector from a buffer (3 floats)
/// 2-3 {number} arguments initializes the vector's x, y, z params.
/// GMFMOD_VECTORs are used to set and get 3D positional values.
/// @copyright Aaron Ishibashi, 2021.

/// @struct GMFMOD_VECTOR([x, y, z])
/// @param {number|GMFMOD_Buffer} [x_or_buf]
/// @param {number} [y]
/// @param {number} [z]
///
function GMFMOD_VECTOR() constructor
{
	// ===== Initialization =======================================================
	
	if (argument_count == 3)
	{
		x = argument[0];
		y = argument[1];
		z = argument[2];
	}
	else if (argument_count == 2)
	{
		x = argument[0];
		y = argument[1];
		z = 0;
	}
	else
	{
		x = 0;           
		y = 0;           
		z = 0; 
	}
	// ---------------------------------------------------------------------------
	
	/// @func readFromBuffer(buf: GMFMOD_Buffer)->void
	/// @param {GMFMOD_Buffer} buf
	///
	/// @desc Reads data from a buffer and assigns the data to this struct.
	static readFromBuffer = function(buf/*: GMFMOD_Buffer*/)
	{
		x = buf.read(buffer_f32);	
		y = buf.read(buffer_f32);	
		z = buf.read(buffer_f32);
	};
	
	// Optional initialization via buffer
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
		buf.write(buffer_f32, x);
		buf.write(buffer_f32, y);
		buf.write(buffer_f32, z);
	};
	
	/// @func log()->void
	/// 
	/// @desc Logs struct data to the console.
	static log = function()
	{
		show_debug_message("GMFMOD_VECTOR: { " + string(x) + ", " + 
			string(y) + ", " + string(z) + " }");	
	};
}

// Hints for GMEdit
/// @hint GMFMOD_VECTOR:readFromBuffer(buf: GMFMOD_Buffer)->void
/// @hint GMFMOD_VECTOR:writeToBuffer(buf: GMFMOD_Buffer)->void
/// @hint GMFMOD_VECTOR:log()->void
