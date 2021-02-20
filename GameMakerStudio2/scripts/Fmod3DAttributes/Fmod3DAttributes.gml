/// @function Fmod3DAttributes([buffer])
function Fmod3DAttributes() constructor 
{
	// Initialize each member
    position = new FmodVector(); /// @is {FmodVector} Position in 3D space (left-handed by default)
    velocity = new FmodVector(); /// @is {FmodVector} Velocity in 3D space (left-handed by default)
    forward = new FmodVector();  /// @is {FmodVector} Forward direction (forms a 90-degree angle with "up")
    up = new FmodVector();       /// @is {FmodVector} Up direction (forms a 90-degree angle with "forward")
    
    static assignFromBuffer = function(buf/*: FmodBuffer*/)
    {
        position.assignFromBuffer(buf);
        velocity.assignFromBuffer(buf);
        forward.assignFromBuffer(buf);
        up.assignFromBuffer(buf);
    };
    
    static sendToBuffer = function(buf/*: FmodBuffer*/)
    {
        position.sendToBuffer(buf);
        velocity.sendToBuffer(buf);
        forward.sendToBuffer(buf);
        up.sendToBuffer(buf);
    };
	
	static log = function()
	{
		show_debug_message("===== Fmod3DAttributes Log =====");
		position.log();	
		velocity.log();
		forward.log();
		up.log();
	};
}

// GMEdit hints
/// @hint Fmod3DAttributes:assignFromBuffer(buf: FmodBuffer)->void Populates the data of this struct from a buffer.
/// @hint Fmod3DAttributes:sendToBuffer(buf: FmodBuffer)->void Populates a buffer with data from this struct.
/// @hint Fmod3DAttributes:log()->void Logs the data of this struct to the console.
