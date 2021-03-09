// Inherit the parent event
event_inherited();

// Initialize FMOD Stduio
checkedupdate = false;
studio = new GMFMOD_Studio_System();

GMFMOD_Assert(studio.isValid(), true, "StudioSystem is valid");


