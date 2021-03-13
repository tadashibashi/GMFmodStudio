function GMFMOD_Studio_System() constructor
{
	// "Private" variables
	studio_ = GMFMOD_Ptr(fmod_studio_system_create());
	core_ = GMFMOD_Ptr(fmod_studio_system_get_core_system(studio_));
	
// ============================================================================
// Lifetime
// ============================================================================
	
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
	static release = function()
	{
		fmod_studio_system_release(studio_);
	};
	
// ============================================================================
// Update
// ============================================================================
	
	/// @returns {void}
	static update = function()
	{
		fmod_studio_system_update(studio_);
	};
	
	/// @returns {void}
	static flushCommands = function()
	{
		fmod_studio_system_flush_commands(studio_);	
	};
	
	/// @returns {void}
	static flushSampleLoading = function()
	{
		fmod_studio_system_flush_sample_loading(studio_);
	};
	
// ============================================================================
// Banks
// ============================================================================
	
	/// @param {string} bankpath  relative to the working_directory
	/// @param {int}    flags     value from FMOD_STUDIO_LOAD_BANK_FLAGS
	/// @param {GMFMOD_Studio_Bank} [bank] (optional) bank to assign to 
	/// @returns {GMFMOD_Studio_Bank}
	static loadBankFile = function(bankpath, flags, bank)
	{
		/// @description Load a GMFMOD_Studio_Bank from a file
		
		var bank_handle = fmod_studio_system_load_bank_file(
			studio_, 
			working_directory + bankpath, 
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
	
	/// @param   {string}             path
	/// @param   {GMFMOD_Studio_Bank} [bank] (optional) if you want to provide your own object to assign new bank to.
	/// @returns {GMFMOD_Studio_Bank}
	static getBank = function(path, bank)
	{
		var bankhandle = fmod_studio_system_get_bank(studio_, path);
		if (instanceof(bank) == "GMFMOD_Studio_Bank")
			bank.assign(bankhandle);
		else
			bank = new GMFMOD_Studio_Bank(bankhandle);
		
		return bank;
	};
	
	/// @param   {GMFMOD_GUID} guid
	/// @param   {GMFMOD_Studio_Bank} [bank] (optional) if you want to provide your own object to assign new bank to.
	/// @returns {GMFMOD_Studio_Bank}
	static getBankByID = function(guid, bank)
	{
		var buf = GMFMOD_GetBuffer();
		guid.writeToBuffer(buf);
		
		var bankhandle = fmod_studio_system_get_bank_by_id(studio_, buf.getAddress());
		if (instanceof(bank) == "GMFMOD_Studio_Bank")
			bank.assign(bankhandle);
		else
			bank = new GMFMOD_Studio_Bank(bankhandle);
			
		
		return bank;
	};
	
	/// @returns {number}
	static getBankCount = function()
	{
		return fmod_studio_system_get_bank_count(studio_);	
	};
	
	
	/// note: please use sparingly, since dynamic memory is allocated on every call to this function.
    /// @param {array<any>} [arr] a pre-defined array to populate, otherwise the function creates and returns a new one.
    /// @returns {array<GMFMOD_Studio_Bank>}
    static getBankList = function(arr)
    {
        var count = fmod_studio_system_get_bank_count(studio_);
        
        if (GMFMOD_GetError() != FMOD_OK)
            return [];
        
        var buf/*: GMFMOD_Buffer*/ = GMFMOD_GetBuffer();
        var capacity = count * 8;
        buf.allocate(capacity); // ensure buffer is big enough. 8 is sizeof byte
        
        // Fill buffer with pointers
        fmod_studio_system_get_bank_list(studio_, capacity, buf.getAddress());
        
        if (GMFMOD_GetError() == FMOD_OK)
        {
            // No errors, commit changes
            if (is_array(arr))           // user provided array, resize
                array_resize(arr, count);
            else                         // array not provided, create a new one
                arr = array_create(count);
                
            for (var i = 0; i < count; ++i) // populate array
                arr[@i] = new GMFMOD_Studio_Bank(buf.read(buffer_u64));
                
            return arr;
        }
        else
        {
            return [];
        }
    };
    
// ============================================================================
// Listeners
// ============================================================================
	
	/// @param   {number}               listener_index
	/// @param   {GMFMOD_3D_ATTRIBUTES} attributes
	/// @returns {void}
	static setListenerAttributes = function(listener_index, attributes)
	{
		var buf = GMFMOD_GetBuffer();
		attributes.writeToBuffer(buf);
		fmod_studio_system_set_listener_attributes(studio_, listener_index, 
			buf.getAddress());
	};
	
	/// @param   {number}               listener_index
	/// @param   {GMFMOD_3D_ATTRIBUTES} [attributes] (optional) if you want to provide your own object to assign values to.
	/// @returns {GMFMOD_3D_ATTRIBUTES}
	static getListenerAttributes = function(listener_index, attributes)
	{
		var buf = GMFMOD_GetBuffer();
		fmod_studio_system_get_listener_attributes(studio_, listener_index, buf.getAddress());
		
		if (instanceof(attributes) == "GMFMOD_3D_ATTRIBUTES")
			attributes.readFromBuffer(buf);
		else
			attributes = new GMFMOD_3D_ATTRIBUTES(buf);
		
		return attributes;
	};
	
	
	/// @param   {number} listener_index
	/// @param   {number} weight
	/// @returns {void}
	static setListenerWeight = function(listener_index, weight)
	{
		fmod_studio_system_set_listener_weight(studio_, listener_index, weight);
	};
	
	
	/// @param   {number} listener_index
	/// @returns {number}   
	static getListenerWeight = function(listener_index)
	{
		return fmod_studio_system_get_listener_weight(studio_, listener_index);	
	};
	
	
	/// @param   {number} numlisteners
	/// @returns {void}
	static setNumListeners = function(numlisteners)
	{
		fmod_studio_system_set_num_listeners(studio_, numlisteners);	
	};
	
	
	/// @returns {number}
	static getNumListeners = function()
	{
		return fmod_studio_system_get_num_listeners(studio_);	
	};

// ============================================================================
// Busses
// ============================================================================
	
	/// @param {string} path
	/// @param {GMFMOD_Studio_Bus} [bus] (optional) if you want to provide your own object to populate
	/// @returns {GMFMOD_Studio_Bus}
	static getBus = function(path, bus)
	{
		var bushandle = fmod_studio_system_get_bus(studio_, path);	
		if (instanceof(bus) == "GMFMOD_Studio_Bus")
			bus.assign(bushandle);
		else
			bus = new GMFMOD_Studio_Bus(bushandle);
		
		return bus;
	};
	
	
	/// @param   {GMFMOD_GUID}       guid
	/// @param   {GMFMOD_Studio_Bus} [bus] (optional) if you want to provide your own object to populate.
	/// @returns {GMFMOD_Studio_Bus}
	static getBusByID = function(guid, bus)
	{
		var buf = GMFMOD_GetBuffer();
		guid.writeToBuffer(buf);
		
		var handle = fmod_studio_system_get_bus_by_id(studio_, buf.getAddress());
		if (instanceof(bus) == "GMFMOD_Studio_Bus")
			bus.assign(handle);
		else
			bus = new GMFMOD_Studio_Bus(handle);
		
		return bus;	
	};
	
	
// ============================================================================
// Events
// ============================================================================
	
	// Gets an FmodEventDescription object
	/// @param {string} event_path
	/// @param {GMFMOD_Studio_EventDescription} [evdesc] optional Event Description object to populate
	static getEvent = function(event_path, evdesc)
	{
		var handle = fmod_studio_system_get_event(studio_, event_path);
		if (instanceof(evdesc) == "GMFMOD_Studio_EventDescription")
			evdesc.assign(handle);
		else
			evdesc = new GMFMOD_Studio_EventDescription(handle);
		
		return evdesc;
	};
	
	
	/// @param {GMFMOD_GUID} guid object containing id info
	/// @param {GMFMOD_Studio_EventDescription} [evdesc] (optional) if you want to provide your own EventDescription object
	static getEventByID = function(guid, evdesc)
	{
		var buf = GMFMOD_GetBuffer();
		guid.writeToBuffer(buf);
		
		var handle = fmod_studio_system_get_event_by_id(studio_, buf.getAddress());
		
		if (instanceof(evdesc) == "GMFMOD_Studio_EventDescription")
			evdesc.assign(handle);
		else
			evdesc = new GMFMOD_Studio_EventDescription(handle);

		return evdesc; 
	};
	
// ============================================================================
// Parameters
// ============================================================================
	// Sets a global parameter value
	/// @param   {string} name
	/// @param   {number} value
	/// @param   {bool}   [ignoreseek = false]
	///       true:   instantly set the value
	///       false:  take seek time into account
	/// @returns {void}
	static setParameterByName = function(name, value, ignoreseek)
	{
		if (ignoreseek == undefined) ignoreseek = false;
		
		fmod_studio_system_set_parameter_by_name(studio_, name, value, ignoreseek);	
	};
	
	// Gets a global parameter value
	/// @param   {string} name
	/// @returns {number}
	static getParameterByName = function(name)
	{
		return fmod_studio_system_get_parameter_by_name(studio_, name);
	};
	
	/// @param {string} name
	/// @returns {number}
	static getParameterByNameFinal = function(name)
	{
		return fmod_studio_system_get_parameter_by_name_final(studio_, name);
	};
	
	// Sets a global parameter value accessed by param id
	/// @param   {GMFMOD_STUDIO_PARAMETER_ID} param_id
	/// @param   {number}                     value
	/// @param   {bool}                       [ignoreseek = false]
	///       true:   instantly set the value
	///       false:  take seek time into account
	/// @returns {void}
	static setParameterByID = function(param_id, value, ignoreseek)
	{
		var buf = GMFMOD_GetBuffer();
		param_id.writeToBuffer(buf);
		
		if (ignoreseek == undefined) ignoreseek = false;
		
		fmod_studio_system_set_parameter_by_id(studio_, buf.getAddress(), value, 
			ignoreseek);
	};
	
	// Gets a global parameter value accessed by param id
	/// @param {GMFMOD_STUDIO_PARAMETER_ID} param_id
	/// @returns
	static getParameterByID = function(param_id)
	{
		var buf = GMFMOD_GetBuffer();
		param_id.writeToBuffer(buf);
		
		return fmod_studio_system_get_parameter_by_id(studio_, 
			buf.getAddress());
	};	
	
	// Gets a global parameter value accessed by param id
	/// @param   {GMFMOD_STUDIO_PARAMETER_ID} param_id
	/// @returns {number}
	static getParameterByIDFinal = function(param_id)
	{
		var buf = GMFMOD_GetBuffer();
		param_id.writeToBuffer(buf);
		
		return fmod_studio_system_get_parameter_by_id_final(studio_, 
			buf.getAddress());
	};
	
	
	// Sets multiple global parameters by ids and values at once. Make sure 
	// param_ids and values arrays correspond to each other by order and are the 
	// same length.
	/// @param {array<GMFMOD_STUDIO_PARAMETER_ID>} param_ids
	/// @param {array<number>}                     values
	/// @param {bool}                              [ignoreseek = false]
	static setParametersByIDs = function(param_ids, values, ignoreseek)
	{
		var count = array_length(param_ids);
		if (ignoreseek == undefined) ignoreseek = false;
		
		var buf = GMFMOD_GetBuffer();
		for (var i = 0; i < count; ++i)
		{
			param_ids[i].writeToBuffer(buf);
			buf.write(buffer_f32, values[i]);
		}
		
		fmod_studio_system_set_parameters_by_ids(studio_, buf.getAddress(),
			count, ignoreseek);
	};
	
	/// @returns {number}
	static getParameterDescriptionCount = function()
	{
		return fmod_studio_system_get_paramdesc_count(studio_);	
	};
	
	/// @param {number} index
	/// @param {GMFMOD_STUDIO_PARAMETER_DESCRIPTION} [paramdesc] (optional) 
	///          if you want to provide your own object to overwrite its values.
	/// @returns {GMFMOD_STUDIO_PARAMETER_DESCRIPTION}
	static getParameterDescriptionByIndex = function(index, paramdesc)
	{
		var buf = GMFMOD_GetBuffer();
		fmod_studio_system_get_paramdesc_by_index(studio_, index, 
			buf.getAddress());
		
		if (instanceof(paramdesc) == "GMFMOD_STUDIO_PARAMETER_DESCRIPTION")
			paramdesc.readFromBuffer(buf);
		else
			paramdesc = new GMFMOD_STUDIO_PARAMETER_DESCRIPTION(buf);
		
		return paramdesc;
	};
	
// ============================================================================
// VCA
// ============================================================================
	/// @param {string} path
	/// @param {GMFMOD_Studio_VCA} [vca] (optional) if you want to provide your
	///                 own object to fill.
	/// @returns {GMFMOD_Studio_VCA}
	static getVCA = function(path, vca)
	{
		var handle = fmod_studio_system_get_vca(studio_, path);
		if (instanceof(vca) == "GMFMOD_Studio_VCA")
			vca.assign(handle);
		else
			vca = new GMFMOD_Studio_VCA(handle);
		
		return vca;
	};	
	
	/// @param {GMFMOD_GUID} guid
	/// @param {GMFMOD_Studio_VCA} [vca] (optional) if you want to provide your
	///                 own object to fill.
	/// @returns {GMFMOD_Studio_VCA}
	static getVCAByID = function(guid, vca)
	{
		var buf = GMFMOD_GetBuffer();
		guid.writeToBuffer(buf);
		
		var handle = fmod_studio_system_get_vca_by_id(studio_, buf.getAddress());
		if (instanceof(vca) == "GMFMOD_Studio_VCA")
			vca.assign(handle);
		else
			vca = new GMFMOD_Studio_VCA(handle);
		
		return vca;
	};
	
// ============================================================================
// Advanced Settings
// ============================================================================
	/// @param {GMFMOD_STUDIO_ADVANCED_SETTINGS} [advsettings] (optional) if you
	///             want to provide your own object to fill.
	/// @returns {GMFMOD_STUDIO_ADVANCED_SETTINGS}
	static getAdvancedSettings = function(advsettings)
	{
		var buf = GMFMOD_GetBuffer();
		fmod_studio_system_get_advanced_settings(studio_, buf.getAddress());
		
		if (instanceof(advsettings) == "GMFMOD_STUDIO_ADVANCED_SETTINGS")
			advsettings.readFromBuffer(buf);
		else
			advsettings = new GMFMOD_STUDIO_ADVANCED_SETTINGS(buf);
		
		return advsettings;
	};
	
	
	/// @param {GMFMOD_STUDIO_ADVANCED_SETTINGS} advsettings
	/// @returns {void}
	static setAdvancedSettings = function(advsettings)
	{
		var buf = GMFMOD_GetBuffer();
		advsettings.writeToBuffer(buf);
		fmod_studio_system_set_advanced_settings(studio_, buf.getAddress());
	};


// ============================================================================
// Command Capture and Replay
// ============================================================================
	/// @param   {string} filename relative to working_directory
	/// @param   {number} commandcaptureflags
	/// @returns {void}
	static startCommandCapture = function(filename, commandcaptureflags)
	{
		fmod_studio_system_start_command_capture(studio_, 
			working_directory + filename, 
			commandcaptureflags);
	};
	
	
	/// @returns {void}
	static stopCommandCapture = function()
	{
		fmod_studio_system_stop_command_capture(studio_);	
	};
	
	
	/// @param   {string} filename
	/// @param   {number} commandreplayflags flags from FMOD_STUDIO_COMMANDREPLAY_*
	/// @param   {GMFMOD_Studio_CommandReplay} [commandreplay] (optional) if you
	///               want to provide your own object to accept values to.
	/// @returns {GMFMOD_Studio_CommandReplay}
	static loadCommandReplay = function(filename, commandreplayflags, 
		commandreplay)
	{
		var handle = fmod_studio_system_load_command_replay(studio_, 
			working_directory + filename, 
			commandreplayflags);
		
		if (instanceof(commandreplay) == "GMFMOD_Studio_CommandReplay")
			commandreplay.assign(handle, self);
		else
			commandreplay = new GMFMOD_Studio_CommandReplay(handle, self);
		
		return commandreplay;
	};
	
// ============================================================================
// Profiling (Must use a logging version of the FMOD dlls to work)
// ============================================================================
	/// @param   {GMFMOD_STUDIO_BUFFER_USAGE} [bufferusage]
	/// @returns {GMFMOD_STUDIO_BUFFER_USAGE}
	static getBufferUsage = function(bufferusage)
	{
		var buf = GMFMOD_GetBuffer();
		fmod_studio_system_get_buffer_usage(studio_, buf.getAddress());
		
		if (instanceof(bufferusage) == "GMFMOD_STUDIO_BUFFER_USAGE")
			bufferusage.readFromBuffer(buf);
		else
			bufferusage = new GMFMOD_STUDIO_BUFFER_USAGE(buf);
		
		return bufferusage;
	};
	
	/// @returns {void}
	static resetBufferUsage = function()
	{
		fmod_studio_system_reset_buffer_usage(studio_);
	};
	
	
	/// @param   {GMFMOD_STUDIO_CPU_USAGE} [cpuusage] (optional) to provide own 
	///               object to receive data.
	/// @returns {GMFMOD_STUDIO_CPU_USAGE}
	static getCPUUsage = function(cpuusage)
	{
		var buf = GMFMOD_GetBuffer();
		fmod_studio_system_get_cpu_usage(studio_, buf.getAddress());
		
		if (instanceof(cpuusage) == "GMFMOD_STUDIO_CPU_USAGE")
			cpuusage.readFromBuffer(buf);
		else
			cpuusage = new GMFMOD_STUDIO_CPU_USAGE(buf);
		
		return cpuusage;
	}
	
	
	/// @param   {GMFMOD_STUDIO_MEMORY_USAGE} [memusage] (optional) to provide
	///               own object to receive data. Creates a new one if not.
	/// @returns {GMFMOD_STUDIO_MEMORY_USAGE}
	static getMemoryUsage = function(memusage)
	{
		var buf = GMFMOD_GetBuffer();
		fmod_studio_system_get_memory_usage(studio_, buf.getAddress());
		
		if (instanceof(memusage) == "GMFMOD_STUDIO_MEMORY_USAGE")
			memusage.readFromBuffer(buf);
		else
			memusage = new GMFMOD_STUDIO_MEMORY_USAGE(buf);
		
		return memusage;
	};

// ============================================================================
// General
// ============================================================================
	
	/// @param   {number} callbackmask "or" together the 
	///                      FMOD_STUDIO_SYSTEM_CALLBACK_* constants to listen to.
	/// @returns {void}
	static setCallback = function(callbackmask)
	{
		fmod_studio_system_set_callback(studio_, callbackmask);
	};
	
	// Get core system currently not supported.
	
	/// @param {GMFMOD_GUID}
	/// @returns {string}
	static lookupPath = function(guid)
	{
		var buf = GMFMOD_GetBuffer();
		guid.writeToBuffer(buf);
		
		return fmod_studio_system_lookup_path(studio_, buf.getAddress());
	};
	
	/// @param   {string}      path
	/// @param   {GMFMOD_GUID} [guid] (optional) to provide your own guid object 
	///                               to assign values to, otherwise the function 
	///                               will create a new one.
	/// @returns {GMFMOD_GUID}
	static lookupID = function(path, guid)
	{
		var buf = GMFMOD_GetBuffer();
		fmod_studio_system_lookup_id(studio_, path, buf.getAddress());
		
		if (instanceof(guid) == "GMFMOD_GUID")
			guid.readFromBuffer(buf);
		else
			guid = new GMFMOD_GUID(buf);
		
		return guid;
	};
	
	/// @returns {bool}
	static isValid = function()
	{
		return fmod_studio_system_is_valid(studio_);	
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
		return new GMFMOD_Studio_EventInstance_AudioTable(evhandle);
	};
}

/// @hint {pointer} GMFMOD_Studio_System:studio_ [private] pointer to the studio system  
/// @hint {pointer} GMFMOD_Studio_System:core_ [private] pointer to the core system  
/// @hint GMFMOD_Studio_System:initialize(max_channels: int, studio_flags: int, flags: int)->void Initializes the FMOD Studio System object. Must be called before any other function is called.