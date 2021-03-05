/// @struct                GMFMOD_GUID([buf: GMFMOD_Buffer])
/// @param {GMFMOD_Buffer}  [buf:GMFMOD_Buffer] buffer to initialize data from
function GMFMOD_GUID() constructor
{
	/// @description     A GML representation of the FMOD_GUID object. 
    ///                  Contains helper functions to manage buffer transfer to 
    ///                  and from the GMFmodStudio extension.

	// ===== Initialization ======================================================
	data1 = 0; /// @is {int} unsigned int32
	data2 = 0; /// @is {int} unsigned int16
	data3 = 0; /// @is {int} unsigned int16
	data4 = array_create(8, 0); /// @is {Array<int>} unsigned int8
	// ---------------------------------------------------------------------------


	/// @function                 readFromBuffer(buf: GMFMOD_Buffer)->void
	/// @param   {GMFMOD_Buffer}   buf The buffer to read from.
	/// @returns {void}
	static readFromBuffer = function(buf/*: GMFMOD_Buffer*/)
	{
		/// @description    Reads data from a buffer and assigns it to this struct.
		///                 GMFMOD_Buffer buf should have its position currently pointed where 
		///                 the next call to "read" will return the first GUID data value.
		///                 (This is automatically handled by GMFMS wrapper objects.)
		
		data1 = buf.read(buffer_u32);
		data2 = buf.read(buffer_u16);
		data3 = buf.read(buffer_u16);
		
		for (var i = 0; i < 8; ++i)
		{
			data4[i] = buf.read(buffer_u8);	
		}
	};
	
	// Optional buffer initialization handling.
	if (argument_count == 1 && instanceof(argument[0]) == "GMFMOD_Buffer")
	{
		readFromBuffer(argument[0]);	
	}
	
	
	
	/// @function                 writeToBuffer(buf: GMFMOD_Buffer)->void
	/// @param   {GMFMOD_Buffer}   buf The buffer to write to.
	/// @returns {void}
	static writeToBuffer = function(buf/*: GMFMOD_Buffer*/)
	{
		/// @description    Writes data from this struct into a buffer.

		buf.write(buffer_u32, data1);
		buf.write(buffer_u16, data2);
		buf.write(buffer_u16, data3);
		
		for (var i = 0; i < 8; ++i)
		{
			buf.write(buffer_u8, data4[i]);	
		}
	};
	
	
	/// @function                 log()->void
	/// @returns {void}
	static log = function()
	{
		/// @description    Logs struct data to the console.
		
		show_debug_message("==== FMOD_GUID Data ====");
		show_debug_message("Data1: " + string(data1));
		show_debug_message("Data2: " + string(data2));
		show_debug_message("Data3: " + string(data3));
		for (var i = 0; i < 8; ++i)
			show_debug_message("Data4[" + string(i) + "]: " + string(data4[i]));
	};
	
	/// @function        equals(guid: GMFMOD_GUID)->bool
	/// @returns  {bool}
	static equals = function(guid)
	{
		/// @description    Checks if another guid obtains the same value
		
		if (instanceof(guid) != "GMFMOD_Buffer")
			return false;
		return (data1 == guid.data1 && data2 == guid.data2 &&
				data3 == guid.data3 && 
				data4[0] == guid.data4[0] && data4[1] == guid.data4[1] &&
				data4[2] == guid.data4[2] && data4[3] == guid.data4[3] &&
				data4[4] == guid.data4[4] && data4[5] == guid.data4[5] &&
				data4[6] == guid.data4[6] && data4[7] == guid.data4[7]
				);
	}
}

// GMEdit Hints ===============================================================
/// @hint GMFMOD_GUID:readFromBuffer(buf: GMFMOD_Buffer)->void Assigns data to this GMFMOD_GUID from a buffer
/// @hint GMFMOD_GUID:writeToBuffer(buf: GMFMOD_Buffer)->void Sends data from this GMFMOD_GUID into a buffer
/// @hint GMFMOD_GUID:log()->void Log struct data to the console.
/// @hint GMFMOD_GUID:equals(guid: GMFMOD_GUID)->bool Checks if another guid contains the same value
