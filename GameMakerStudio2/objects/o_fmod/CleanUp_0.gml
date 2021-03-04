/// @description Insert description here
// You can write your code in this editor

if (variable_instance_exists(self, "system"))
{
	system.unloadAll();
	system.flushCommands();
	system.release();
}