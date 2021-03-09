// Update FMOD Studio
fmod_studio_system_update(studio);

if (!checkedupdate)
{
	GMFMOD_Assert(GMFMOD_GetError(), FMOD_OK, "Studio System Update");	
	checkedupdate = true;
}
