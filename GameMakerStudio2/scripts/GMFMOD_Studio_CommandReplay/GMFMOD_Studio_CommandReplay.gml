/// @file Lightweight wrapper for an FMOD::Studio::CommandReplay object
 
/// @struct GMFMOD_Studio_CommandReplay([handle]: int)
/// @param {number} [handle]
/// @param {GMFMOD_Studio_System} studiosystem
function GMFMOD_Studio_CommandReplay() constructor 
{
    comrep_ = pointer_null; /// @is {pointer}
    system_ = pointer_null;
    
    /// @param   {number} handle handle pointer to assign
    /// @param   {GMFMOD_Studio_System} system object reference.
    /// @returns {void}   No return value. For error checking, check 
    ///                   GMFMOD_GetError() == FMOD_OK.
    ///                   Most likely, if there is an error, it will have been 
    ///                   posted by the function retrieving this bank.
    static assign = function(handle, system)
    {
        var comrep = GMFMOD_Ptr(handle);
        if (fmod_studio_comreplay_is_valid(comrep))
        {
        	// Clean up if there is already a valid command replay
        	// assigned to this object
        	if (fmod_studio_comreplay_is_valid(comrep_))
        	{
        		// Stop if playing
        		if (fmod_studio_comreplay_get_playback_state(comrep_) !=
        			FMOD_STUDIO_PLAYBACK_STOPPED)
    			{
    				fmod_studio_comreplay_stop(comrep_);
    			}
    			
    			// Free resources
    			fmod_studio_comreplay_release(comrep_);
        	}
        	
        	// Assign new CommandReplay
        	 comrep_ = comrep;
        	 system_ = system;
        }
		else
		{
			show_debug_message("GMFMOD Error: Attempted to assign an invalid handle to " 
				+ "a " + string(instanceof(self)) + " object!");
		}
    };
    
    
    // Assignment handling during construction
    if (argument_count == 2 && is_numeric(argument[0]) && 
    	instanceof(argument[1]) == "GMFMOD_Studio_System")
    {
        assign(argument[0], argument[1]);
    }
    
    
    /// @param {string} path relative to working_directory
    /// @returns {void}
    static setBankPath = function(path)
    {
    	fmod_studio_comreplay_set_bank_path(comrep_, working_directory + path);	
    };
    
    
    /// @returns {void}
    static setCreateInstanceCallback = function()
    {
    	fmod_studio_comreplay_set_create_instance_callback(comrep_);	
    };
    
    
    /// @returns {void}
    static setFrameCallback = function()
    {
    	fmod_studio_comreplay_set_frame_callback(comrep_);	
    };
    
    
    /// @returns {void}
    static setLoadBankCallback = function()
    {
    	fmod_studio_comreplay_set_load_bank_callback(comrep_);	
    };
    
    
    /// @returns {void}
    static start = function()
    {
    	fmod_studio_comreplay_start(comrep_);	
    };
    
    
    /// @returns {void}
    static stop = function()
    {
    	fmod_studio_comreplay_stop(comrep_);	
    };
    
    
    /// @returns {number} command index
    static getCurrentCommandIndex = function()
    {
    	return fmod_studio_comreplay_get_current_command_index(comrep_);	
    };    
    
    
    /// @returns {number} current command's activation time
    static getCurrentCommandTime = function()
    {
    	return fmod_studio_comreplay_get_current_command_time(comrep_);	
    };
    
    
    /// @returns {number} playback state from FMOD_STUDIO_PLAYBACK_*
    static getPlaybackState = function()
    {
    	return fmod_studio_comreplay_get_playback_state(comrep_);	
    };
    
    
    /// @param   {bool} paused
    /// @returns {void}
    static setPaused = function(paused)
    {
    	fmod_studio_comreplay_set_paused(comrep_, paused);	
    };
    
    
    /// @returns {bool} paused state
    static getPaused = function()
    {
    	return fmod_studio_comreplay_get_paused(comrep_);	
    };
    
    
    /// @param {number} commandindex
    /// @returns {void}
    static seekToCommand = function(commandindex)
    {
    	fmod_studio_comreplay_seek_to_command(comrep_, commandindex);	
    };
    
    
    /// @param {number} seconds
    /// @returns {void}
    static seekToTime = function(seconds)
    {
    	fmod_studio_comreplay_seek_to_time(comrep_, seconds);	
    };
    
    
    /// @param {number} seconds
    /// @returns {number} command index at that time
    static getCommandAtTime = function(seconds)
    {
    	return fmod_studio_comreplay_get_command_at_time(comrep_, seconds);	
    };
    
    
    /// @returns {number}
    static getCommandCount = function()
    {
    	return fmod_studio_comreplay_get_command_count(comrep_);
    };
    
    
    /// @param {number} commandindex
    /// @param {GMFMOD_STUDIO_COMMAND_INFO} [commandinfo] (optional) if you want
    ///				to provide your own object to receive values.
    /// @returns {GMFMOD_STUDIO_COMMAND_INFO}
    static getCommandInfo = function(commandindex, commandinfo)
    {
    	var buf = GMFMOD_GetBuffer();
    	fmod_studio_comreplay_get_command_info(comrep_, commandindex, 
    		buf.getAddress());
    	
    	if (instanceof(commandinfo) == "GMFMOD_STUDIO_COMMAND_INFO")
    		commandinfo.readFromBuffer(buf);
    	else
    		commandinfo = new GMFMOD_STUDIO_COMMAND_INFO(buf);
    		
    	return commandinfo;
    };
    
    
    /// @param {number} commandindex
    /// @returns {string}
    static getCommandString = function(commandindex)
    {
    	return fmod_studio_comreplay_get_command_string(comrep_, commandindex);	
    };
    
    
    /// @returns {number} in seconds
    static getLength = function()
    {
    	return fmod_studio_comreplay_get_length(comrep_);
    };
    
    
    /// @returns {GMFMOD_Studio_System} system object that created this
    static getSystem = function()
    {
    	return system_;	
    };
    
    
    /// @returns {bool}
    static isValid = function()
    {
    	return fmod_studio_comreplay_is_valid(comrep_);
    };
    
    
    /// @returns {void}
    static release = function()
    {
    	fmod_studio_comreplay_release(comrep_);	
    };
}
