/// @file Lightweight wrapper for an FMOD::Studio::Bank object
 
/// @struct GMFMOD_Studio_Bank([handle]: int)
/// @param {number} [handle]
function GMFMOD_Studio_Bank() constructor 
{
    bank_ = pointer_null; /// @is {pointer}
    
    /// @param   {number} handle handle pointer to assign
    /// @returns {void}   No return value. For error checking, check 
    ///                   GMFMOD_GetError() == FMOD_OK.
    ///                   Most likely, if there is an error, it will have been 
    ///                   posted by the function retrieving this bank.
    static assign = function(handle)
    {
        var bank = GMFMOD_Ptr(handle);
        if (fmod_studio_bank_is_valid(bank))
            bank_ = bank;
		else
			show_debug_message("GMFMOD Error: Attempted to assign an invalid handle to " 
				+ "a " + string(instanceof(self)) + " object!");
    };
    
    // Assignment handling during construction
    if (argument_count > 0 && is_numeric(argument[0]))
    {
        assign(argument[0]);
    }
    
    
    /// @returns {number} the loading state constant (FMOD_STUDIO_LOADING_STATE_*)
    static getLoadingState = function()
    {
        return fmod_studio_bank_get_loading_state(bank_);
    };
    
    /// @returns {void}
    static loadSampleData = function()
    {
        fmod_studio_bank_load_sample_data(bank_);
    };
    
    /// @returns {void}
    static unloadSampleData = function()
    {
        fmod_studio_bank_unload_sample_data(bank_);
    };
    
    /// @returns {number} the loading state constant (FMOD_STUDIO_LOADING_STATE_*)
    static getSampleLoadingState = function()
    {
        return fmod_studio_bank_get_sample_loading_state(bank_);
    };
    
    /// @returns {void}
    static unload = function()
    {
    	fmod_studio_bank_unload(bank_);	
    };
    
    /// @returns {number} the number of busses in this bank
    static getBusCount = function()
    {
        return fmod_studio_bank_get_bus_count(bank_);
    };
    
    /// note: please use sparingly, since dynamic memory is allocated on every call.
    /// @param {array<any>} [arr] a pre-defined array to populate, otherwise the function creates and returns a new one.
    /// @returns {array<GMFMOD_Studio_Bus>}
    static getBusList = function(arr)
    {
        var count = fmod_studio_bank_get_bus_count(bank_);
        
        if (GMFMOD_GetError() != FMOD_OK)
            return [];
        
        var buf/*: GMFMOD_Buffer*/ = GMFMOD_GetBuffer();
        buf.allocate(count * 8); // ensure buffer is big enough. 8 is sizeof byte
        
        // Fill buffer with pointers
        fmod_studio_bank_get_bus_list(bank_, count, buf.getAddress());
        
        if (GMFMOD_GetError() == FMOD_OK)
        {
            // No errors, commit changes
            if (arr == undefined)           // user did not provide array: create
                arr = array_create(count);
            else                            // user provided one, resize
                array_resize(arr, count);
                
            for (var i = 0; i < count; ++i) // populate array
                arr[@i] = new GMFMOD_Studio_Bus(buf.read(buffer_u64));
            
            return arr;
        }
        else
        {
            return [];
        }
    };
    
    /// @returns {number} the number of events in this bank
    static getEventCount = function()
    {
        return fmod_studio_bank_get_event_count(bank_);
    }
    
    /// note: please use sparingly, since dynamic memory is allocated on every call to this function.
    /// @param {array<any>} [arr] a pre-defined array to populate, otherwise the function creates and returns a new one.
    /// @returns {array<GMFMOD_Studio_EventDescription>}
    static getEventList = function(arr)
    {
        var count = fmod_studio_bank_get_event_count(bank_);
        
        if (GMFMOD_GetError() != FMOD_OK)
            return [];
        
        var buf/*: GMFMOD_Buffer*/ = GMFMOD_GetBuffer();
        buf.allocate(count * 8); // ensure buffer is big enough. 8 is sizeof byte
        
        // Fill buffer with pointers
        fmod_studio_bank_get_event_list(bank_, count, buf.getAddress());
        
        if (GMFMOD_GetError() == FMOD_OK)
        {
            // No errors, commit changes
            if (is_array(arr))
            	array_resize(arr, count);
            else                       
            	arr = array_create(count);
                
            for (var i = 0; i < count; ++i) // populate array
            {
            	arr[@i] = new GMFMOD_Studio_EventDescription(
                	buf.read(buffer_u64));
            }

            return arr;
        }
        else
        {
            return [];
        }
    };    
    
    
    /// @returns {number} the number of vca's in this bank
    static getVCACount = function()
    {
        return fmod_studio_bank_get_vca_count(bank_);
    }
    
    
    /// note: please use sparingly, since dynamic memory is allocated on every call to this function.
    /// @param {array<any>} [arr] a pre-defined array to populate, otherwise the function creates and returns a new one.
    /// @returns {array<GMFMOD_Studio_EventDescription>}
    static getVCAList = function(arr)
    {
        var count = fmod_studio_bank_get_vca_count(bank_);
        
        if (GMFMOD_GetError() != FMOD_OK)
            return [];
        
        var buf/*: GMFMOD_Buffer*/ = GMFMOD_GetBuffer();
        buf.allocate(count * 8); // ensure buffer is big enough. 8 is sizeof byte
        
        // Fill buffer with pointers
        fmod_studio_bank_get_vca_list(bank_, count, buf.getAddress());
        
        if (GMFMOD_GetError() == FMOD_OK)
        {
            // No errors, commit changes
            if (arr == undefined)           // user did not provide array: create
                arr = array_create(count);
            else                            // user provided one, resize
                array_resize(arr, count);
                
            for (var i = 0; i < count; ++i) // populate array
                arr[@i] = new GMFMOD_Studio_VCA(buf.read(buffer_u64));
                
            return arr;
        }
        else
        {
            return [];
        }
    };
    
    
    /// @returns {number} the number of strings in this bank. Use on ".strings.bank" files.
    static getStringCount = function()
    {
        return fmod_studio_bank_get_string_count(bank_);
    };
    
    
    /// @param {number} index index of the string to get the guid of
    /// @param {GMFMOD_GUID} [guid] (optional) assign guid to a pre-existing object. 
    ///                                        If undefined, creates a new one.
    /// @returns {GMFMOD_GUID}
    static getStringInfoID = function(index, guid)
    {
        var buf/*: GMFMOD_Buffer*/ = GMFMOD_GetBuffer();
        if (guid == undefined)
            guid = new GMFMOD_GUID(buf);
        
        fmod_studio_bank_get_string_info_id(bank_, buf.getAddress(), index);
        if (GMFMOD_GetError() == FMOD_OK)
        {
            guid.readFromBuffer(buf);
        }
        
        return guid;
    };
    
    
    /// @param   {number} index the path
    /// @returns {string} path
    static getStringInfoPath = function(index)
    {
        return fmod_studio_bank_get_string_info_path(bank_, index);
    };
    
    
    /// @param   {GMFMOD_GUID} [guid] (optional) assign guid to a pre-existing object,
    ///                                or if undefined, creates a new one.
    /// @returns {GMFMOD_GUID}
    static getID = function(guid)
    {
        var buf/*: GMFMOD_Buffer*/ = GMFMOD_GetBuffer();
        fmod_studio_bank_get_id(bank_, buf.getAddress());
        
        if (instanceof(guid) == "GMFMOD_GUID")
            guid.readFromBuffer(buf);
        else
        	guid = new GMFMOD_GUID(buf);
        
        return guid;
    };
    
    
    /// @returns {string} the bank path
    static getPath = function()
    {
        return fmod_studio_bank_get_path(bank_);
    };
    
    
    /// @returns {bool} Whether or not the internal pointer is a valid FMOD object handle.
    ///                 E.g. Unloading this bank will invalidate this object.
    static isValid = function()
    {
        return fmod_studio_bank_is_valid(bank_);
    };
}

/// @hint GMFMOD_Studio_Bank:assign(handle: number) Assigns pointer retrieved from a GMFMOD fmod function. Overwrites the current data.