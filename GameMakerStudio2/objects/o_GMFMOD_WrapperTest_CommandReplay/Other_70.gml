/// @description Callback Tests
var map = async_load;

if (map[?"fmodCallbackType"] == "CommandReplayCreateInstance")
{
	if (!received_createinst_callback)
	{
		GMFMOD_Assert(GMFMOD_Ptr(map[?"replay"]), comrep.comrep_, 
			"Received CommandReplayCreateInstance Callback");
		received_createinst_callback = true;
	}
}

if (map[?"fmodCallbackType"] == "CommandReplayLoadBank")
{
	if (!received_load_bank_callback)
	{
		GMFMOD_Assert(GMFMOD_Ptr(map[?"replay"]), comrep.comrep_, 
			"Received CommandReplayLoadBank Callback");
		received_load_bank_callback = true;
	}
}

if (map[?"fmodCallbackType"] == "CommandReplayFrame")
{
	if (!received_frame_callback)
	{
		GMFMOD_Assert(GMFMOD_Ptr(map[?"replay"]), comrep.comrep_, 
			"Received CommandReplayFrame Callback");
		received_frame_callback = true;
	}
}
