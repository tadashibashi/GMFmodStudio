/// @function FmodVector([x, y, z])
/// @description Constructor initializes an FmodVector. Must include all three arguments or none at all.
/// FmodVectors are used to set and get 3D positional values
function FmodVector() constructor
{
	if (argument_count == 3)
	{
		x = argument[0];
		y = argument[1];
		z = argument[2];
	}
	else
	{
		x = 0;
		y = 0;
		z = 0;
	}
	
	static assignFromBuffer = function(buf)
	{
		x = buf.read(buffer_f32);	
		y = buf.read(buffer_f32);	
		z = buf.read(buffer_f32);	
	};
	
	static sendToBuffer = function(buf)
	{
		buf.write(buffer_f32, x);
		buf.write(buffer_f32, y);
		buf.write(buffer_f32, z);
	};
	
	static log = function()
	{
		show_debug_message("FmodVector: { " + string(x) + ", " + 
			string(y) + ", " + string(z) + " }");	
	};
}

// Hints for GMEdit
/// @hint FmodVector:assignFromBuffer(buf: FmodBuffer)->void
/// @hint FmodVector:sendToBuffer(buf: FmodBuffer)->void
/// @hint FmodVector:log()->void
