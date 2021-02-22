function GMFMS_System() constructor
{
	// "Private" variables
	studio_ = GMFMS_HandleToPtr(fmod_studio_system_create());
	core_ = GMFMS_HandleToPtr(fmod_studio_system_get_core_system(studio_));
	
	// Initializes the FMOD Studio object. Must be called before performing any
	// other functions.
	/// @param {int} max_channels the max number of channels to initialize fmod studio with.
	/// @param {int} studio_flags the flags to initialize FMOD Studio System with.
	/// @param {int} flags the flags to initialize FMOD System with.
	static initialize = function(max_channels, studio_flags, flags)
	{
		fmod_studio_system_initialize(studio_, max_channels, studio_flags, flags);
	};
	
	// Shuts down and releases studio resources.
	static release = function()
	{
		return fmod_studio_system_release(studio_);	
	};
	
	static update = function()
	{
		return fmod_studio_system_update(studio_);
	};
	
	static flushCommands = function()
	{
		return fmod_studio_system_flush_commands(studio_);	
	};
	
	// Gets an FmodEventDescription object
	static getEvent = function(event_path)
	{
		var evdesc = fmod_studio_system_get_event(studio_, event_path);
		if (evdesc == 0) {
			throw "FMOD Studio error: " + GMFMS_GetErrorString();
		}
			
		return new GMFMS_EvDesc(evdesc);
	};
	
	static getEventByID = function(fmod_guid)
	{
		var buf = GMFMS_GetBuffer();
		fmod_guid.writeToBuffer(buf);
		fmod_guid.log();
		
		var evdesc = fmod_studio_system_get_event_by_id(studio_, buf.getAddress());
		if (evdesc == 0) {
			throw "FMOD Studio error: " + GMFMS_GetErrorString();
		}
		
		return new GMFMS_EvDesc(evdesc);
	};
	
	/// @function createAudioTableInst(prog_ev_path, key)
	/// @param {string} prog_ev_path path to an event that contains a Programmer Instrument
	/// @param {string} key audio table key.
	static createAudioTableInst = function(prog_ev_path, key)
	{
		var evhandle = gmfms_audiotable_event_create(studio_, key, prog_ev_path);
		return new GMFMS_EvInst_AudioTable(evhandle);
	};
	
	// Load a Studio Bank file
	static loadBankFile = function(bank_path)
	{
		return fmod_studio_system_load_bank_file(studio_, bank_path);	
	};
	
	// Unload all studio banks
	static unloadAll = function()
	{
		return fmod_studio_system_unload_all(studio_);
	};
	
	static getHandle = function()
	{
		return studio_;	
	};
	
	static getCoreHandle = function()
	{
		return core_;
	};
}

/// @hint GMFMS_System:initialize(max_channels: int, studio_flags: int, flags: int)->void Initializes the FMOD Studio System object. Must be called before any other function is called.