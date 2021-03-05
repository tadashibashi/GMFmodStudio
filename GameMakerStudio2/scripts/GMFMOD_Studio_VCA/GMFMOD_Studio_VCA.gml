/// @file Lightweight wrapper for an FMOD::Studio::VCA object
 
/// @struct GMFMOD_Studio_VCA([handle]: int)
/// @param {number} [handle]
function GMFMOD_Studio_VCA() constructor 
{
    vca_ = pointer_null; /// @is {pointer}
    
    /// @param   {number} handle handle pointer to assign
    /// @returns {void}   No return value. For error checking, check 
    ///                   GMFMOD_GetError() == FMOD_OK.
    ///                   Most likely, if there is an error, it will have been 
    ///                   posted by the function retrieving this bank.
    static assign = function(handle)
    {
        var vca = GMFMOD_Ptr(handle);
        if (fmod_studio_vca_is_valid(vca))
            vca_ = vca;
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
