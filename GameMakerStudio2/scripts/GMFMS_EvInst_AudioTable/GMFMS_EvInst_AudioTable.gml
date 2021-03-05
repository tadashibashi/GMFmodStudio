/// @function GMFMOD_Studio_EventInstance([handle]: int)
/// @description Extension of an EventInstance that plays from the Bank's audio table.
///     Change keys with changeKey. This will not have an effect until the next programmer instrument starts playing.
///     Do not create directly. Please use createAudioTableInst function from GMFMOD_Studio_System object
/// @param {int} handle (optional) default: pointer_null. You can assign this value later via assign function.
function GMFMOD_Studio_EventInstance_AudioTable(_handle) : GMFMOD_Studio_EventInstance(_handle) constructor
{
	static changeKey = function(key)
	{
		gmfms_audiotable_event_change_key(inst_, key);	
	};
	
	static release = function()
	{
		return gmfms_audiotable_event_release(inst_);	
	};
}
