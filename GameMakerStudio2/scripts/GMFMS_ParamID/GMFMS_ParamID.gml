
function GMFMS_ParamID() constructor
{
	data1 = 0;
	data2 = 0;
	
	static readFromBuffer = function(buf)
	{
		data1 = buf.read(buffer_u32);
		data2 = buf.read(buffer_u32);
	}
	
	static writeToBuffer = function(buf)
	{
		buf.write(buffer_u32, data1);
		buf.write(buffer_u32, data2);
	}
}