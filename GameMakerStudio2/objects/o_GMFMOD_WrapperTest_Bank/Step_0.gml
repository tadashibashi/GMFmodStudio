
bank.unload();
GMFMOD_Check("Unloading bank");

stringsbank.unload();
GMFMOD_Check("Unloading strings bank");

studio.flushCommands();
GMFMOD_Check("Flushing commands");

GMFMOD_Assert(bank.isValid(), false, "Bank invalidated after unload");
GMFMOD_Assert(stringsbank.isValid(), false, 
    "Strings bank invalidated after unload");

finish();
