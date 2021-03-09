var map = async_load;

if (map[?"fmodCallbackType"] == "CommandReplayCreateInstance")
{
	if (!recd_create_instance_callback)
	{
		GMFMOD_Assert(GMFMOD_Ptr(map[?"replay"]), com, 
			"Received CommandReplayCreateInstance Callback");
		recd_create_instance_callback = true;
	}
}

if (map[?"fmodCallbackType"] == "CommandReplayLoadBank")
{
	if (!recd_load_bank_callback)
	{
		GMFMOD_Assert(GMFMOD_Ptr(map[?"replay"]), com, 
			"Received CommandReplayLoadBank Callback");
		recd_load_bank_callback = true;
	}
}

if (map[?"fmodCallbackType"] == "CommandReplayFrame")
{
	if (!recd_frame_callback)
	{
		GMFMOD_Assert(GMFMOD_Ptr(map[?"replay"]), com, 
			"Received CommandReplayFrame Callback");
		recd_frame_callback = true;
	}
}
