/// @file Info for buffer usage in FMOD Studio. 
/// Implementation of the FMOD_STUDIO_BUFFER_USAGE object.
/// @copyright Aaron Ishibashi, 2021.

/// @struct GMFMOD_STUDIO_BUFFER_USAGE([buf]: GMFMOD_Buffer)
/// @param {GMFMOD_Buffer} [buf] (optional) Buffer with which to initialize this 
/// object from.
function GMFMOD_STUDIO_BUFFER_USAGE() constructor
{
	studiocommandqueue = new GMFMOD_STUDIO_BUFFER_INFO();  /// @is {GMFMOD_STUDIO_BUFFER_INFO}
	studiohandle =       new GMFMOD_STUDIO_BUFFER_INFO();  /// @is {GMFMOD_STUDIO_BUFFER_INFO}

	/// @func readFromBuffer(buf: GMFMOD_Buffer)
	/// @desc Populates this object with the contents form a buffer.
	/// @returns {void}
	static readFromBuffer = function(buf)
	{
		studiocommandqueue.readFromBuffer(buf);
		studiohandle.readFromBuffer(buf);
	};
	
	if (argument_count == 1 && instanceof(argument[0]) == "GMFMOD_Buffer")
	{
		readFromBuffer(argument[0]);	
	}
	
	/// @func writeToBuffer(buf: GMFMOD_Buffer)
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
		show_debug_message("===== GMFMOD_STUDIO_BUFFER_USAGE Log =====");	
		show_debug_message("VVVVV studiocommandqueue VVVVV");
		studiocommandqueue.log();
		show_debug_message("VVVVV studiohandle VVVVV");
		studiohandle.log();
	};
}

// GMEdit Hints ===============================================================
/// @hint GMFMOD_STUDIO_BUFFER_USAGE:readFromBuffer(buf: GMFMOD_Buffer)->void Reads data from a buffer and assigns it to this struct.
/// @hint GMFMOD_STUDIO_BUFFER_USAGE:writeFromBuffer(buf: GMFMOD_Buffer)->void Writes data from this struct into a buffer.
/// @hint GMFMOD_STUDIO_BUFFER_USAGE:log()->void Logs the data from this struct into the console.
