++timer;

if (timer == 10)
{
	if (inst.isValid())
	{
		inst.stop(FMOD_STUDIO_STOP_IMMEDIATE);
		inst.release();
	}

	finish();
}