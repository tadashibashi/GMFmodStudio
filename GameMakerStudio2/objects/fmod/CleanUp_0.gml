/// @description Insert description here
// You can write your code in this editor

if (variable_instance_exists(self, "studio"))
{
	studio.unloadAll();
	GMFMOD_Check("Unloading all banks");
	
	studio.release();
	GMFMOD_Check("Releasing studio system");
	
	studio.flushCommands();
	GMFMOD_Check("Flushing commands");
}
