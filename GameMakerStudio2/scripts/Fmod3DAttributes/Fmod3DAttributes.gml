/// @function Fmod3DAttributes([buffer])
function Fmod3DAttributes() constructor 
{
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
}
