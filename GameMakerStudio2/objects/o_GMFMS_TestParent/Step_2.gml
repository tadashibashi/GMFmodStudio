// Update FMOD Studio
fmod_studio_system_update(studio);

if (!checkedupdate)
{
	GMFMS_Assert(GMFMS_GetError(), FMOD_OK, "Studio System Update");	
	checkedupdate = true;
}
