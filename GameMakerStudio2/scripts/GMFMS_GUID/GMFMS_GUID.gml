/// @struct                GMFMS_GUID([buf: GMFMS_Buffer])
/// @param {GMFMS_Buffer}  [buf:GMFMS_Buffer] buffer to initialize data from
function GMFMS_GUID() constructor
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


	/// @function                 readFromBuffer(buf: GMFMS_Buffer)->void
	/// @param   {GMFMS_Buffer}   buf The buffer to read from.
	/// @returns {void}
	static readFromBuffer = function(buf/*: GMFMS_Buffer*/)
	{
		/// @description    Reads data from a buffer and assigns it to this struct.
		///                 GMFMS_Buffer buf should have its position currently pointed where 
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
	if (argument_count == 1 && instanceof(argument[0]) == "GMFMS_Buffer")
	{
		readFromBuffer(argument[0]);	
	}
	
	
	
	/// @function                 writeToBuffer(buf: GMFMS_Buffer)->void
	/// @param   {GMFMS_Buffer}   buf The buffer to write to.
	/// @returns {void}
	static writeToBuffer = function(buf/*: GMFMS_Buffer*/)
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
}

// GMEdit Hints ===============================================================
/// @hint GMFMS_GUID:readFromBuffer(buf: GMFMS_Buffer)->void Assigns data to this GMFMS_GUID from a buffer
/// @hint GMFMS_GUID:writeToBuffer(buf: GMFMS_Buffer)->void Sends data from this GMFMS_GUID into a buffer
/// @hint GMFMS_GUID:log()->void Log struct data to the console.
