/// @file A GML representation of the FMOD_3D_ATTRIBUTES struct.
/// Contains helper functions to manage buffer transfer to and from the 
/// GMFmodStudio extension.
/// This struct is used to pass 3D positional data to and from FMOD Studio.
/// @copyright Aaron Ishibashi, 2021.

/// @struct GMFMOD_3D_ATTRIBUTES([buffer])
/// @param {GMFMOD_Buffer} [buffer] Buffer to initialize data from.
///
function GMFMOD_3D_ATTRIBUTES() constructor 
{
	// ===== Initialization ======================================================
	
    position = new GMFMOD_VECTOR(); /// @is {GMFMOD_VECTOR} Position in 3D space (left-handed by default)
    velocity = new GMFMOD_VECTOR(); /// @is {GMFMOD_VECTOR} Velocity in 3D space (left-handed by default)
    forward = new GMFMOD_VECTOR();  /// @is {GMFMOD_VECTOR} Forward direction (forms a 90-degree angle with "up")
    up = new GMFMOD_VECTOR();       /// @is {GMFMOD_VECTOR} Up direction (forms a 90-degree angle with "forward")
 	// ---------------------------------------------------------------------------   
    
    /// @func readFromBuffer(buf: GMFMOD_Buffer)->void
    /// @param {GMFMOD_Buffer} buf
    ///
    /// @desc Read data from a buffer and assign it to this struct.
    static readFromBuffer = function(buf/*: GMFMOD_Buffer*/)
    {
        position.readFromBuffer(buf);
        velocity.readFromBuffer(buf);
        forward.readFromBuffer(buf);
        up.readFromBuffer(buf);
    };
	
	if (argument_count == 1 && instanceof(argument[0]) == "GMFMOD_Buffer")
	{
			readFromBuffer(argument[0]);
	}
    
    /// @func writeToBuffer(buf: GMFMOD_Buffer)->void
    /// @param {GMFMOD_Buffer} buf
    ///
    /// @desc Write data to a buffer from this struct.
    static writeToBuffer = function(buf/*: GMFMOD_Buffer*/)
    {
        position.writeToBuffer(buf);
        velocity.writeToBuffer(buf);
        forward.writeToBuffer(buf);
        up.writeToBuffer(buf);
    };
	
	/// @func log()->void
    ///
    /// @desc Log the data from this struct to the console.
	static log = function()
	{
		show_debug_message("===== GMFMOD_3D_ATTRIBUTES Log =====");
		position.log();	
		velocity.log();
		forward.log();
		up.log();
	};
}

// GMEdit Hints ===============================================================
/// @hint GMFMOD_3D_ATTRIBUTES:readFromBuffer(buf: GMFMOD_Buffer)->void Populates the data of this struct from a buffer.
/// @hint GMFMOD_3D_ATTRIBUTES:writeToBuffer(buf: GMFMOD_Buffer)->void Populates a buffer with data from this struct.
/// @hint GMFMOD_3D_ATTRIBUTES:log()->void Logs the data of this struct to the console.
