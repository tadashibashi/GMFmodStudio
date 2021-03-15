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
				+ "a " + string(instanceof(self)) + " object!");
    };
    
    // Assignment handling during construction
    if (argument_count > 0)
    {
        assign(argument[0]);
    }
    
    
    /// @param {number}
    /// @returns {void}
    static setVolume = function(volume)
    {
    	fmod_studio_vca_set_volume(vca_, volume);	
    };    
    
  
    /// @returns {number}
    static getVolume = function()
    {
    	return fmod_studio_vca_get_volume(vca_);	
    };
    
    static getVolumeFinal = function()
    {
    	return fmod_studio_vca_get_volume_final(vca_);	
    };
    
    
    /// @param   {GMFMOD_GUID} [guid] (optional) if you want to provide your own
	/// 					object to receive values.
	/// @returns {GMFMOD_GUID}
	static getID = function(guid)
	{
		var buf = GMFMOD_GetBuffer();
		fmod_studio_vca_get_id(vca_, buf.getAddress());
		
		if (instanceof(guid) == "GMFMOD_GUID")
			guid.readFromBuffer(buf);
		else
			guid = new GMFMOD_GUID(buf);
			
		return guid;
	};
	
	
	/// @returns {string}
	static getPath = function()
	{
		return fmod_studio_vca_get_path(vca_);
	};
	
	
	/// @returns {bool}
	static isValid = function()
	{
		return fmod_studio_vca_is_valid(vca_);	
	};
}
