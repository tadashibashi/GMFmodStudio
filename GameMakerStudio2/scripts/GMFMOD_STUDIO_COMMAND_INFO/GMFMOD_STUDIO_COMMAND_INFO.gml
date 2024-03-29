/// @file A GML representation of the FMOD_STUDIO_COMMAND_INFO struct.
/// Contains helper functions to manage buffer transfer to and from the 
/// GMFmodStudio extension.
/// @copyright Aaron Ishibashi, 2021.

/// @struct GMFMOD_STUDIO_COMMAND_INFO([buffer: GMFMOD_Buffer])
/// @param {GMFMOD_Buffer} [buffer] (optional) initialization via buffer.
///
function GMFMOD_STUDIO_COMMAND_INFO() constructor
{
	// ===== Initialization ======================================================
	
	commandname = "";
	parentcommandindex = -1;
	framenumber = -1;
	frametime = -1;
	instancetype = -1;
	outputtype = -1;
	instancehandle = 0;
	outputhandle = 0;
	// ---------------------------------------------------------------------------
	
	/// @func readFromBuffer(buf: GMFMOD_Buffer)->void
	/// @param {GMFMOD_Buffer} buf
	///
	/// @desc Read data from a buffer and assign it to this struct.
	static readFromBuffer = function(buf)
	{
		 commandname = __GMFMOD_InterpretString(buf.read(buffer_u64));
		 parentcommandindex = buf.read(buffer_s32);
		 framenumber = buf.read(buffer_s32);
		 frametime = buf.read(buffer_f32);
		 instancetype = buf.read(buffer_u32);
		 outputtype = buf.read(buffer_u32);
		 instancehandle = buf.read(buffer_u32);
		 outputhandle = buf.read(buffer_u32);
	};
	
	// Optional initialization via buffer
	if (argument_count == 1 && instanceof(argument[0]) == "GMFMOD_Buffer")
	{
		readFromBuffer(argument[0]);	
	}
	
	/// @func log()->void
	///
	/// @desc Log data from this struct to the console.
	static log = function()
	{
		show_debug_message("===== GMFMOD_STUDIO_COMMAND_INFO Log =====");
		show_debug_message("commandname: " + commandname);
		show_debug_message("parentcommandindex: " + string(parentcommandindex));
		show_debug_message("framenumber: " + string(framenumber));
		show_debug_message("frametime: " + string(frametime));
		show_debug_message("instancetype: " + string(instancetype));
		show_debug_message("outputtype: " + string(outputtype));
		show_debug_message("instancehandle: " + string(instancehandle));
		show_debug_message("outputhandle: " + string(outputhandle));
	};
}

// GMEdit Hints ===============================================================
/// @hint GMFMOD_STUDIO_COMMAND_INFO:readFromBuffer(buf: GMFMOD_Buffer)->void Read data from a buffer and assign it to this struct.
/// @hint GMFMOD_STUDIO_COMMAND_INFO:log()->void Log struct data to the console.
