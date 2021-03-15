/// @description Insert description here
// You can write your code in this editor

timer++;

if (timer == 120)
{
	test();
}

if (timer == 240)
{
	// Clean up the Command Replay Object
	fmod_studio_comreplay_stop(com);
	fmod_studio_comreplay_release(com);
	fmod_studio_system_flush_commands(studio);
	
	GMFMOD_Assert(fmod_studio_comreplay_is_valid(com), false,
		"ComReplay Released");
		
	GMFMOD_Assert(recd_create_instance_callback &&
		recd_frame_callback &&
		recd_load_bank_callback,
		true,
		"Received all callbacks");	
	
	finish();
}

if (timer == 1)
{
	fmod_studio_evinst_start(eimusic);
}

if (timer == 10 * 5)
{
	fmod_studio_evinst_stop(eimusic, FMOD_STUDIO_STOP_ALLOWFADEOUT);
	fmod_studio_evinst_release(eimusic);
}

if (timer == 10 * 1 || timer == 10 * 2 || timer == 10 * 3 || timer == 10 * 4)
{
	var evdesc = GMFMOD_Ptr(fmod_studio_system_get_event(studio, "event:/UIBlip"));
	var evinst = GMFMOD_Ptr(fmod_studio_evdesc_create_instance(evdesc));
	fmod_studio_evinst_start(evinst);
	fmod_studio_evinst_release(evinst);
}