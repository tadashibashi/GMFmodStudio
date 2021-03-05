/// @file Lightweight wrapper for an FMOD::Studio::CommandReplay object
 
/// @struct GMFMOD_Studio_CommandReplay([handle]: int)
/// @param {number} [handle]
function GMFMOD_Studio_CommandReplay() constructor 
{
    comrep_ = pointer_null; /// @is {pointer}
    
    /// @param   {number} handle handle pointer to assign
    /// @returns {void}   No return value. For error checking, check 
    ///                   GMFMOD_GetError() == FMOD_OK.
    ///                   Most likely, if there is an error, it will have been 
    ///                   posted by the function retrieving this bank.
    static assign = function(handle)
    {
        var comrep = GMFMOD_Ptr(handle);
        if (fmod_studio_comreplay_is_valid(comrep))
            comrep_ = comrep;
		else
			show_debug_message("GMFMOD Error: Attempted to assign an invalid handle to " 
				+ "a " + instanceof(self) + " object!");
    };
    
    // Assignment handling during construction
    if (argument_count > 0 && is_numeric(argument[0]))
    {
        assign(argument[0]);
    }
}
