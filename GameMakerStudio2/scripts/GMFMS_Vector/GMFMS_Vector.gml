/// @function GMFMS_Vector([x, y, z])
/// @description Constructor initializes a GMFMS_Vector. Must include all three arguments or none at all.
/// GMFMS_Vectors are used to set and get 3D positional values
function GMFMS_Vector() constructor
{
	x = 0;           /// @is {number}
	y = 0;           /// @is {number}
	z = 0;           /// @is {number}
	if (argument_count == 3)
	{
		x = argument[0];
		y = argument[1];
		z = argument[2];
	}
	
	static readFromBuffer = function(buf)
	{
		x = buf.read(buffer_f32);	
		y = buf.read(buffer_f32);	
		z = buf.read(buffer_f32);	
	};
	
	static writeToBuffer = function(buf)
	{
		buf.write(buffer_f32, x);
		buf.write(buffer_f32, y);
		buf.write(buffer_f32, z);
	};
	
	static log = function()
	{
		show_debug_message("GMFMS_Vector: { " + string(x) + ", " + 
			string(y) + ", " + string(z) + " }");	
	};
}

// Hints for GMEdit
/// @hint GMFMS_Vector:readFromBuffer(buf: GMFMS_Buffer)->void
/// @hint GMFMS_Vector:writeToBuffer(buf: GMFMS_Buffer)->void
/// @hint GMFMS_Vector:log()->void
