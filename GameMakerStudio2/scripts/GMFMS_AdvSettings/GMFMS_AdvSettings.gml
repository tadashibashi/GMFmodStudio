function GMFMS_AdvSettings() constructor
{
	commandqueusize = -1;         /// @is {int} uint_32_t
	handleinitialsize = -1;       /// @is {int} uint_32_t
	studioupdateperiod = -1;      /// @is {int} int_32_t
	idlesampledatapoolsize = -1;  /// @is {int} int32_t
	streamingscheduledelay = -1;  /// @is {int} uint_32_t
	encryptionkey = "";           /// @is {string}
	
	/// @function readFromBuffer(buf: GMFMS_Buffer)
	/// @description Populates this object with the contents form a buffer.
	/// @returns {void}
	static readFromBuffer = function(buf)
	{
		commandqueusize = buf.read(buffer_u32);
		handleinitialsize = buf.read(buffer_u32);
		studioupdateperiod = buf.read(buffer_s32);
		idlesampledatapoolsize = buf.read(buffer_s32);
		streamingscheduledelay = buf.read(buffer_u32);
		encryptionkey = buf.read(buffer_string);
	};
	
	if (argument_count == 1 && instanceof(argument[0] == "GMFMS_Buffer"))
	{
		readFromBuffer(argument[0]);	
	}
	
	/// @function writeToBuffer(buf: GMFMS_Buffer)
	/// @description Writes this object's internal data to a buffer.
	/// @returns {void}
	static writeToBuffer = function(buf)
	{
		buf.write(buffer_u32, commandqueusize);
		buf.write(buffer_u32, handleinitialsize);
		buf.write(buffer_s32, studioupdateperiod);
		buf.write(buffer_s32, idlesampledatapoolsize);
		buf.write(buffer_u32, streamingscheduledelay);
		buf.write(buffer_string, encryptionkey);
	};
	
	/// @function log()
	/// @description Logs this object's internal data to the console.
	/// @returns {void}
	static log = function()
	{
		show_debug_message("===== GMFMS_AdvSettings Log =====");	
		show_debug_message("commandqueusize: " + string(commandqueusize));	
		show_debug_message("handleinitialsize: " + string(handleinitialsize));	
		show_debug_message("studioupdateperiod: " + string(studioupdateperiod));	
		show_debug_message("idlesampledatapoolsize: " + string(idlesampledatapoolsize));	
		show_debug_message("streamingscheduledelay: " + string(streamingscheduledelay));	
		show_debug_message("encryptionkey: " + encryptionkey);	
	};
}