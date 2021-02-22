function FmodStudioCommandInfo() constructor
{
	commandname = "";
	parentcommandindex = -1;
	framenumber = -1;
	frametime = -1;
	instancetype = -1;
	outputtype = -1;
	instancehandle = 0;
	outputhandle = 0;
	
	static readFromBuffer = function(buf)
	{
		 commandname = gmfms_interpret_string(buf.read(buffer_u64));
		 parentcommandindex = buf.read(buffer_s32);
		 framenumber = buf.read(buffer_s32);
		 frametime = buf.read(buffer_f32);
		 instancetype = buf.read(buffer_u32);
		 outputtype = buf.read(buffer_u32);
		 instancehandle = buf.read(buffer_u32);
		 outputhandle = buf.read(buffer_u32);
	};
	
	if (argument_count == 1 && instanceof(argument[0]) == "GMFMS_Buffer")
	{
		readFromBuffer(argument[0]);	
	}
	
	static log = function()
	{
		show_debug_message("===== FmodStudioCommandInfo Log =====");
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