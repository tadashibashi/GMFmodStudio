/// @func GMFMS_BufUsage([buf]: GMFMS_Buffer)
/// @desc Info for buffer usage in FMOD Studio. Implementation of the FMOD_STUDIO_BUFFER_USAGE object.
function GMFMS_BufUsage() constructor
{
	studiocommandqueue = new GMFMS_BufInfo();  /// @is {GMFMS_BufInfo}
	studiohandle =       new GMFMS_BufInfo();  /// @is {GMFMS_BufInfo}
	
	/// @func readFromBuffer(buf: GMFMS_Buffer)
	/// @desc Populates this object with the contents form a buffer.
	/// @returns {void}
	static readFromBuffer = function(buf)
	{
		studiocommandqueue.readFromBuffer(buf);
		studiohandle.readFromBuffer(buf);
	};
	
	if (argument_count == 1 && instanceof(argument[0] == "GMFMS_Buffer"))
	{
		readFromBuffer(argument[0]);	
	}
	
	/// @func writeToBuffer(buf: GMFMS_Buffer)
	/// @desc Writes this object's internal data to a buffer.
	/// @returns {void}
	static writeToBuffer = function(buf)
	{
		studiocommandqueue.writeToBuffer(buf);
		studiohandle.writeToBuffer(buf);
	};
	
	/// @function log()
	/// @description Logs this object's internal data to the console.
	/// @returns {void}
	static log = function()
	{
		show_debug_message("===== GMFMS_BufUsage Log =====");	
		show_debug_message("VVVVV studiocommandqueue VVVVV");
		studiocommandqueue.log();
		show_debug_message("VVVVV studiohandle VVVVV");
		studiohandle.log();
	};
}