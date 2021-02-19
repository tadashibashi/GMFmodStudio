function FmodGUID() constructor
{
	// members
	data1 = 0; /// @is {int} unsigned int32
	data2 = 0; /// @is {int} unsigned int16
	data3 = 0; /// @is {int} unsigned int16
	data4 = array_create(8, 0); /// @is {Array<int>} unsigned int8
	
	/// @desc Assigns this FmodGUID from an FmodBuffer object
	/// FmodBuffer buf should have its head currently pointed where the next 
	/// call to function "read" will read the first GUID data value.
	static assignFromBuffer = function(buf/*: FmodBuffer*/)
	{
		data1 = buf.read(buffer_u32);
		data2 = buf.read(buffer_u16);
		data3 = buf.read(buffer_u16);
		
		for (var i = 0; i < 8; ++i)
		{
			data4[i] = buf.read(buffer_u8);	
		}
	}
	
	/// @desc Dumps data into a buffer in sequence u32, u16, u16, u8[8]
	/// Overwrites FmodBuffer object data starting at beginning of buffer.
	static sendToBuffer = function(buf/*: FmodBuffer*/)
	{
		buf.write(buffer_u32, data1);
		buf.write(buffer_u16, data2);
		buf.write(buffer_u16, data3);
		
		for (var i = 0; i < 8; ++i)
		{
			buf.write(buffer_u8, data4[i]);	
		}
	}
	
	static log = function()
	{
		show_debug_message("==== FMOD_GUID Data ====");
		show_debug_message("Data1: " + string(data1));
		show_debug_message("Data2: " + string(data2));
		show_debug_message("Data3: " + string(data3));
		for (var i = 0; i < 8; ++i)
			show_debug_message("Data4[" + string(i) + "]: " + string(data4[i]));
	}
}

/// @hint FmodGUID:assignFromBuffer(buf: FmodBuffer)->void Assigns data to this FmodGUID from a buffer
/// @hint FmodGUID:sendToBuffer(buf: FmodBuffer)->void Sends data from this FmodGUID into a buffer