// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function FmodStudioParameterID() constructor
{
	data1 = 0;
	data2 = 0;
	
	static assignFromBuffer = function(buf)
	{
		data1 = buf.read(buffer_u32);
		data2 = buf.read(buffer_u32);
	}
	
	static sendToBuffer = function(buf)
	{
		buf.write(buffer_u32, data1);
		buf.write(buffer_u32, data2);
	}
}