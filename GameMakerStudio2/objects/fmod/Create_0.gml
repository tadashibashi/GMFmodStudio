/// @description Insert description here
// You can write your code in this editor

// Keep this runtime manager as a singleton instance
if (instance_exists(fmod))
{
	instance_destroy(self);
	exit;
}

studio = new GMFMOD_Studio_System();

studio.initialize(
	128, 
	FMOD_STUDIO_INIT_NORMAL, 
	FMOD_INIT_NORMAL);
GMFMOD_Check("Initializing Studio System");
