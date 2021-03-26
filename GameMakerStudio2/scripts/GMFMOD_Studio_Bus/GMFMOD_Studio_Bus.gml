/// @file Lightweight wrapper for an FMOD::Studio::Bus object
 
/// @struct GMFMOD_Studio_Bus([handle]: int)
/// @param {number} [handle]
function GMFMOD_Studio_Bus() constructor 
{
    bus_ = pointer_null; /// @is {pointer}
    
    /// @param   {number} handle handle pointer to assign
    /// @returns {void}   No return value. For error checking, check 
    ///                   GMFMOD_GetError() == FMOD_OK.
    ///                   Most likely, if there is an error, it will have been 
    ///                   posted by the function retrieving this bank.
    static assign = function(handle)
    {
        var bus = GMFMOD_Ptr(handle);
        if (fmod_studio_bus_is_valid(bus))
            bus_ = bus;
		else 			
			show_debug_message("GMFMOD Error: Attempted to assign an invalid handle to " 
				+ "a " + string(instanceof(self)) + " object!");
    };
    
    // Assignment handling during construction
    if (argument_count > 0)
    {
        assign(argument[0]);
    }
    
    
    /// @param {bool} paused
    /// @returns {void}
    static setPaused = function(paused)
    {
    	fmod_studio_bus_set_paused(bus_, paused);	
    };    
    
    
    /// @returns {bool}
    static getPaused = function()
    {
    	return fmod_studio_bus_get_paused(bus_);	
    };    
    
    /// @param {number}
    /// @returns {void}
    static setVolume = function(volume)
    {
    	fmod_studio_bus_set_volume(bus_, volume);	
    };    
    
    /// @returns {number}
    static getVolume = function()
    {
    	return fmod_studio_bus_get_volume(bus_);	
    };  
    
    /// @returns {number}
    static getVolumeFinal = function()
    {
    	return fmod_studio_bus_get_volume_final(bus_);
    };
    
    /// @param {bool} mute
    /// @returns {void}
    static setMute = function(mute)
    {
    	fmod_studio_bus_set_mute(bus_, mute);	
    };    
    
    
    /// @returns {bool}
    static getMute = function()
    {
    	return fmod_studio_bus_get_mute(bus_);	
    };    
    
    
    // Get Channel Group not supported.
    
    /// @returns {void}
    static lockChannelGroup = function()
    {
    	fmod_studio_bus_lock_channel_group(bus_);	
    };    
    
    
    /// @returns {void}
    static unlockChannelGroup = function()
    {
    	fmod_studio_bus_unlock_channel_group(bus_);	
    };    
    
    
    /// @param {number} [stopmode = FMOD_STUDIO_STOP_ALLOWFADEOUT]
    /// @returns {void}
    static stopAllEvents = function(stopmode)
    {
    	if (stopmode == undefined) stopmode = FMOD_STUDIO_STOP_ALLOWFADEOUT;
    	fmod_studio_bus_stop_all_events(bus_, stopmode);	
    };
    
    
    /// @param {bool} [exclusiveusage = true]
    /// @returns {number} The cpu time spent processing this unit during the
    ///				last update.
    static getCPUUsage = function(exclusiveusage)
    {
    	if (exclusiveusage == undefined) exclusiveusage = true;
    	
    	if (exclusiveusage)
    		return fmod_studio_bus_get_cpu_usage_exclusive(bus_);
    	else
    		return fmod_studio_bus_get_cpu_usage_inclusive(bus_);
    };    
    
    
    /// @param {GMFMOD_STUDIO_MEMORY_USAGE} [memoryusage] (optional) if you want
    /// 			to provide your own object to receive values.
    /// @returns {number} The cpu time spent processing this unit during the
    ///				last update.
    static getMemoryUsage = function(memoryusage)
    {
		var buf = GMFMOD_GetBuffer();
    	
    	fmod_studio_bus_get_memory_usage(bus_, buf.getAddress());
    	
    	if (instanceof(memoryusage) == "GMFMOD_STUDIO_MEMORY_USAGE")
    		memoryusage.readFromBuffer(buf);
    	else
    		memoryusage = new GMFMOD_STUDIO_MEMORY_USAGE(buf);
    		
    	return memoryusage;
    };
    
    
    /// @param   {GMFMOD_GUID} [guid] (optional) if you want to provide your own
	/// 					object to receive values.
	/// @returns {GMFMOD_GUID}
	static getID = function(guid)
	{
		var buf = GMFMOD_GetBuffer();
		fmod_studio_bus_get_id(bus_, buf.getAddress());
		
		if (instanceof(guid) == "GMFMOD_GUID")
			guid.readFromBuffer(buf);
		else
			guid = new GMFMOD_GUID(buf);
			
		return guid;
	};
	
	
	/// @returns {string}
	static getPath = function()
	{
		return fmod_studio_bus_get_path(bus_);
	};
	
	
	/// @returns {bool}
	static isValid = function()
	{
		return bus_ != pointer_null && fmod_studio_bus_is_valid(bus_);	
	};
}
