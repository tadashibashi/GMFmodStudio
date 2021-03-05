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
				+ "a " + instanceof(self) + " object!");
    };
    
    // Assignment handling during construction
    if (argument_count > 0 && is_numeric(argument[0]))
    {
        assign(argument[0]);
    }
}
