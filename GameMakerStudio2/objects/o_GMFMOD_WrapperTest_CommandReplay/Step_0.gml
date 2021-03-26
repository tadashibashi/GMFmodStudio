/// @description Playback capture timeline

timer++;
if (timer == 1)
{
	instmusic.start();
	GMFMOD_Check("Starting music instance");
}

if (timer == 50)
{
	// ===== Instance Clean up =====
	instmusic.stop(FMOD_STUDIO_STOP_IMMEDIATE);
	GMFMOD_Check("Stopping music instance");
	instmusic.release();
	GMFMOD_Check("Releasing music instance");
	studio.flushCommands();
	GMFMOD_Check("Flushing commands");
}

if (timer == 10 * 1 || timer == 10 * 2 || timer == 10 * 3 || timer == 10 * 4)
{
	instblip.start();
	GMFMOD_Check("Starting instblip");
}

if (timer == 50)
{
	test();
}

if (timer >= 120)
{
	comrep.stop();
	GMFMOD_Check("Stopping command replay");
	
	comrep.release();
	GMFMOD_Check("Releasing command replay");
	
	instblip.stop(FMOD_STUDIO_STOP_IMMEDIATE);
	GMFMOD_Check("Stopping blip instance");
	instblip.release();
	GMFMOD_Check("Releasing blip instance");
	
	studio.flushCommands();
	GMFMOD_Check("Flushing commands");
	
	GMFMOD_Assert(comrep.isValid(), false, "CommandReplay released");
	GMFMOD_Assert(instblip.isValid(), false, "Blip instance released");
	GMFMOD_Assert(instmusic.isValid(), false, "Music instance released");
	
	if (typeof(comrep.comrep_) != "struct")
		GMFMOD_Assert(received_createinst_callback && received_frame_callback &&
			received_load_bank_callback, true, "Received all callbacks");
	
	finish();
}