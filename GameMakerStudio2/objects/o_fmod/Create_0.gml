/// @description Insert description here
// You can write your code in this editor

if (instance_exists(o_fmod))
{
	instance_destroy(self);
	exit;
}

system = GMFMOD_Ptr(fmod_studio_system_create());

fmod_studio_system_initialize(system, 
	128, 
	FMOD_STUDIO_INIT_NORMAL, 
	FMOD_INIT_NORMAL);
GMFMS_Check("Initializing Studio System");

