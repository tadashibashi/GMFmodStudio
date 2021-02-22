/// @function GMFMS_3DAttr([buffer])
function GMFMS_3DAttr() constructor 
{
	// Initialize each member
    position = new GMFMS_Vector(); /// @is {GMFMS_Vector} Position in 3D space (left-handed by default)
    velocity = new GMFMS_Vector(); /// @is {GMFMS_Vector} Velocity in 3D space (left-handed by default)
    forward = new GMFMS_Vector();  /// @is {GMFMS_Vector} Forward direction (forms a 90-degree angle with "up")
    up = new GMFMS_Vector();       /// @is {GMFMS_Vector} Up direction (forms a 90-degree angle with "forward")
    
    static readFromBuffer = function(buf/*: GMFMS_Buffer*/)
    {
        position.readFromBuffer(buf);
        velocity.readFromBuffer(buf);
        forward.readFromBuffer(buf);
        up.readFromBuffer(buf);
    };
    
    static writeToBuffer = function(buf/*: GMFMS_Buffer*/)
    {
        position.writeToBuffer(buf);
        velocity.writeToBuffer(buf);
        forward.writeToBuffer(buf);
        up.writeToBuffer(buf);
    };
	
	static log = function()
	{
		show_debug_message("===== GMFMS_3DAttr Log =====");
		position.log();	
		velocity.log();
		forward.log();
		up.log();
	};
}

// GMEdit hints
/// @hint GMFMS_3DAttr:readFromBuffer(buf: GMFMS_Buffer)->void Populates the data of this struct from a buffer.
/// @hint GMFMS_3DAttr:writeToBuffer(buf: GMFMS_Buffer)->void Populates a buffer with data from this struct.
/// @hint GMFMS_3DAttr:log()->void Logs the data of this struct to the console.
