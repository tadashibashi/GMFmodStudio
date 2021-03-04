/// @file A GML representation of the FMOD_3D_ATTRIBUTES struct.
/// Contains helper functions to manage buffer transfer to and from the 
/// GMFmodStudio extension.
/// This struct is used to pass 3D positional data to and from FMOD Studio.
/// @copyright Aaron Ishibashi, 2021.

/// @struct GMFMOD_3DAttributes([buffer])
/// @param {GMFMS_Buffer} [buffer] Buffer to initialize data from.
///
function GMFMOD_3DAttributes() constructor 
{
	// ===== Initialization ======================================================
	
    position = new GMFMS_Vector(); /// @is {GMFMS_Vector} Position in 3D space (left-handed by default)
    velocity = new GMFMS_Vector(); /// @is {GMFMS_Vector} Velocity in 3D space (left-handed by default)
    forward = new GMFMS_Vector();  /// @is {GMFMS_Vector} Forward direction (forms a 90-degree angle with "up")
    up = new GMFMS_Vector();       /// @is {GMFMS_Vector} Up direction (forms a 90-degree angle with "forward")
 	// ---------------------------------------------------------------------------   
    
    /// @func readFromBuffer(buf: GMFMS_Buffer)->void
    /// @param {GMFMS_Buffer} buf
    ///
    /// @desc Read data from a buffer and assign it to this struct.
    static readFromBuffer = function(buf/*: GMFMS_Buffer*/)
    {
        position.readFromBuffer(buf);
        velocity.readFromBuffer(buf);
        forward.readFromBuffer(buf);
        up.readFromBuffer(buf);
    };
	
	if (argument_count == 1 && instanceof(argument[0]) == "GMFMS_Buffer")
	{
			readFromBuffer(argument[0]);
	}
    
    /// @func writeToBuffer(buf: GMFMS_Buffer)->void
    /// @param {GMFMS_Buffer} buf
    ///
    /// @desc Write data to a buffer from this struct.
    static writeToBuffer = function(buf/*: GMFMS_Buffer*/)
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
		show_debug_message("===== GMFMOD_3DAttributes Log =====");
		position.log();	
		velocity.log();
		forward.log();
		up.log();
	};
}

// GMEdit Hints ===============================================================
/// @hint GMFMOD_3DAttributes:readFromBuffer(buf: GMFMS_Buffer)->void Populates the data of this struct from a buffer.
/// @hint GMFMOD_3DAttributes:writeToBuffer(buf: GMFMS_Buffer)->void Populates a buffer with data from this struct.
/// @hint GMFMOD_3DAttributes:log()->void Logs the data of this struct to the console.
