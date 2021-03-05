function GMFMOD_Studio_System() constructor
{
	// "Private" variables
	studio_ = GMFMOD_Ptr(fmod_studio_system_create());
	core_ = GMFMOD_Ptr(fmod_studio_system_get_core_system(studio_));
	
	/// @param {int} max_channels the max number of channels to initialize fmod studio with.
	/// @param {int} studio_flags the flags to initialize FMOD Studio System with.
	/// @param {int} flags the flags to initialize FMOD System with.
	/// @returns {void}
	static initialize = function(max_channels, studio_flags, flags)
	{
		fmod_studio_system_initialize(studio_, max_channels, studio_flags, flags);
	};
	
	// Shuts down and releases studio resources.
	/// @returns {void}
	static release = function()/*->void*/
	{
		fmod_studio_system_release(studio_);
	};
	
	/// @returns {void}
	static update = function()
	{
		return fmod_studio_system_update(studio_);
	};
	
	static flushCommands = function()
	{
		return fmod_studio_system_flush_commands(studio_);	
	};
	
	// Gets an FmodEventDescription object
	/// @param {string} event_path
	/// @param {GMFMOD_Studio_EventDescription} [evdesc] optional Event Description object to populate
	static getEvent = function(event_path, evdesc)
	{
		var handle = fmod_studio_system_get_event(studio_, event_path);
		if (evdesc == undefined)
			evdesc = new GMFMOD_Studio_EventDescription(handle);
		else
			evdesc.assign(handle);
		return evdesc;
	};
	
	/// @param {GMFMOD_GUID} guid object containing id info
	static getEventByID = function(guid)
	{
		var buf = GMFMOD_GetBuffer();
		fmod_guid.writeToBuffer(buf);
		fmod_guid.log();
		
		var evdesc = fmod_studio_system_get_event_by_id(studio_, buf.getAddress());
		if (evdesc == 0) {
			throw "FMOD Studio error: " + GMFMOD_GetErrorString();
		}
		
		return new GMFMOD_Studio_EventDescription(evdesc);
	};
	
	
	/// @param {string} bankpath
	/// @param {int}    flags     value from FMOD_STUDIO_LOAD_BANK_FLAGS
	/// @param {GMFMOD_Studio_Bank} [bank] (optional) bank to assign to 
	static loadBankFile = function(bankpath, flags, bank)
	{
		/// @description Load a GMFMOD_Studio_Bank from a file
		
		var bank_handle = fmod_studio_system_load_bank_file(
			studio_, 
			bankpath, 
			flags == undefined ? FMOD_STUDIO_LOAD_BANK_NORMAL : flags);
		
		if (bank == undefined) 
			bank = new GMFMOD_Studio_Bank(bank_handle);
		else
			bank.assign(bank_handle);
		
		return bank;
	};
	
	// Unload all studio banks
	/// @returns {void}
	static unloadAll = function()
	{
		fmod_studio_system_unload_all(studio_);
	};
	
	/// @returns {pointer}
	static getHandle = function()
	{
		return studio_;	
	};
	
	/// @returns {pointer}
	static getCoreHandle = function()
	{
		return core_;
	};
	
	/// @param {string} prog_ev_path path to an event that contains a Programmer Instrument
	/// @param {string} key audio table key.
	static createAudioTableInst = function(prog_ev_path, key)
	{
		var evhandle = gmfms_audiotable_event_create(studio_, key, prog_ev_path);
		return new GMFMS_EvInst_AudioTable(evhandle);
	};
}

/// @hint {pointer} GMFMOD_Studio_System:studio_ private pointer to the studio system  
/// @hint {pointer} GMFMOD_Studio_System:core_ private pointer to the core system  
/// @hint GMFMOD_Studio_System:initialize(max_channels: int, studio_flags: int, flags: int)->void Initializes the FMOD Studio System object. Must be called before any other function is called.