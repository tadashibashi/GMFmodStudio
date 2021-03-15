event_inherited();

// Clean up FMOD Studio
studio.unloadAll();
studio.flushCommands();
studio.release();

//GMFMOD_Assert(studio.isValid(), false, "Studio System successfully invalidated");


