/// @file Lightweight wrapper for an FMOD::Studio::Bank object
 
/// @struct GMFMOD_Studio_Bank([handle]: int)
/// @param {number} [handle]
function GMFMOD_Studio_Bank() constructor 
{
    bank_ = pointer_null; /// @is {pointer}
    
    /// @param   {number} handle handle pointer to assign
    /// @returns {void}   No return value. For error checking, check 
    ///                   GMFMOD_GetError == FMOD_OK.
    ///                   Most likely, if there is an error, it will have been 
    ///                   posted by the function retrieving this bank.
    static assign = function(handle)
    {
        var bank = GMFMOD_Ptr(handle);
        if (fmod_studio_bank_is_valid(bank))
            bank_ = bank;
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
    
    /// @returns {number} the number of busses in this bank
    static getBusCount = function()
    {
        return fmod_studio_bank_get_bus_count(bank_);
    };
    
    /// @param {array<any>} a pre-defined array to populate
    static getBusList = function(arr)
    {
        var count = fmod_studio_bank_get_bus_count(bank_);
        if (arr == undefined)
            arr = array_create(count);
        
        var buf/*: GMFMOD_Buffer*/ = GMFMOD_GetBuffer();
        var capacity = count * 8;
        buf.allocate(capacity); // ensure buffer is big enough. 8 is sizeof byte
        
        fmod_studio_bank_get_bus_list(bank_, capacity, buf.getAddress());
        
        for (var i = 0; i < count; ++i)
        {
            arr[@i] = buf.read(buffer_u64);
        }
        
        return arr;
    }
}

/// @hint GMFMOD_Studio_Bank:assign(handle: number) Assigns pointer retrieved from a GMFMOD fmod function. Overwrites the current data.