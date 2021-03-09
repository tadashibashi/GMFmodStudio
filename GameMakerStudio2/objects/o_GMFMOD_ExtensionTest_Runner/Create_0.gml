// Inherit the parent event
event_inherited();

// Run Extension Tests
runTests([
	o_GMFMOD_ExtensionTest_StudioSystem, 
	o_GMFMOD_ExtensionTest_EventDescription,
	o_GMFMOD_ExtensionTest_EventInstance,
	o_GMFMOD_ExtensionTest_CommandReplay,
	o_GMFMOD_ExtensionTest_Bus,
	o_GMFMOD_ExtensionTest_Bank,
	o_GMFMOD_ExtensionTest_VCA]);
