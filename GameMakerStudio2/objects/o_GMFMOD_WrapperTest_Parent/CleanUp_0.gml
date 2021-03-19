event_inherited();

// Clean up FMOD Studio
studio.unloadAll();
studio.release();
studio.flushCommands();

GMFMOD_Assert(studio.isValid(), false, "Studio System successfully invalidated");


