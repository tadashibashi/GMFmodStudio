/// @description Insert description here
// You can write your code in this editor
if (GMFMOD_IntegrationInitialized())
{
	instance_create_depth(0, 0, 0, o_GMFMOD_WrapperTest_Runner);
	instance_destroy(self);
}