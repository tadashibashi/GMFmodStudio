
function GMFMS_MemUsage() constructor
{
	exclusive = -1;  /// @is {int} Size of memory belonging to the bus or event instance.
	inclusive = -1;  /// @is {int} Size of memory belonging exclusively to the bus or event plus inclusive memory sizes of all buses and event instances which route into it.
	sampledata = -1; /// @is {int} Size of shared sample memory referenced by the bus or event instance, inclusive of all sample memory referenced by all buses and event instances which route into it.
	
	static readFromBuffer = function(buf)
	{
		exclusive = buf.read(buffer_s32);
		inclusive = buf.read(buffer_s32);
		sampledata = buf.read(buffer_s32);
	}
	
	if (argument_count == 1 && instanceof(argument[0]) == "GMFMS_Buffer")
	{
		readFromBuffer(argument[0]);	
	}
	
	static log = function()
	{
		show_debug_message("===== GMFMS_MemUsage Log =====");
		show_debug_message("exclusive: " + string(exclusive));
		show_debug_message("inclusive: " + string(inclusive));
		show_debug_message("sampledata: " + string(sampledata));
	}
}
