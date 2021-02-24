timer += delta_time / 1000000;

if (timer > 1)
	finish();
	
//if (!stopped && timer > 15)
//{
//	fmod_studio_evinst_stop(evinst, FMOD_STUDIO_STOP_ALLOWFADEOUT);
//	GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "EventInstance Stop");
//	stopped = true;
//}

//// ============================================================================
//// Event Instance Get/Set Parameter by Name and ID
//// ============================================================================
//var buf = GMFMS_GetBuffer();
//paramdesc_pitch.pid.writeToBuffer(buf);

//fmod_studio_evinst_set_parameter_by_id(evinst, buf.getAddress(), timer / 20);
//fmod_studio_evinst_set_parameter_by_name(evinst, "RoomSize", timer/ 20 * 10);

//if (!checkedParamByName)
//{
//	fmod_studio_system_flush_commands(studio);
	
//	GMFMS_Assert(fmod_studio_evinst_get_parameter_by_id(evinst, buf.getAddress()),
//		timer / 20, "Setting and Getting EvInst Param by ID");
//	GMFMS_Assert(fmod_studio_evinst_get_parameter_by_name(evinst, "RoomSize"), 
//		timer / 20 * 10, "Setting and Getting EvInst Param by Name");
	
	
//	checkedParamByName = true;
//}
