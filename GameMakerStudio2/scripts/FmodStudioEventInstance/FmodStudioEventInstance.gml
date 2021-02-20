// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function FmodStudioEventInstance(_handle) constructor
{
	inst_ = FmodHandleToPtr(_handle);
	
	static start = function()
	{
		return fmod_studio_evinst_start(inst_);	
	};
	
	static stop = function(mode)
	{
		if (mode == undefined) mode = FMOD_STUDIO_STOP_ALLOWFADEOUT;
		
		return fmod_studio_evinst_stop(inst_, mode);	
	};
	
	static release = function()
	{
		return fmod_studio_evinst_release(inst_);	
	};
	
	static getPaused = function()
	{
		return fmod_studio_evinst_get_paused(inst_);	
	};
	
	static setPaused = function(paused)
	{
		return fmod_studio_evinst_set_paused(inst_, paused);	
	};
	
	static getPitch = function()
	{
		return fmod_studio_evinst_get_pitch(inst_);	
	};
	
	static setPitch = function(multiplier)
	{
		return fmod_studio_evinst_set_pitch(inst_, multiplier);	
	};
	
	static get3DAttributes = function(_3D_attr)
	{
		var buf = FmodGetBuffer();
		fmod_studio_evinst_get_3D_attributes(inst_, buf.getAddress());
		
		_3D_attr.assignFromBuffer(buf);
	};
	
	static set3DAttributes = function(_3D_attr)
	{
		var buf = FmodGetBuffer();
		_3D_attr.sendToBuffer(buf);
		fmod_studio_evinst_set_3D_attributes(inst_, buf.getAddress());
	};
	
	static getVolume = function()
	{
		return fmod_studio_evinst_get_volume(inst_);	
	};
	
	static setVolume = function(vol_scale)
	{
		return fmod_studio_evinst_set_volume(inst_, vol_scale);
	};
	
	static setCallback = function(callback_mask)
	{
		return fmod_studio_evinst_set_callback(inst_, callback_mask);	
	};
	
	static getHandle = function()
	{
		return inst_;	
	};
}
