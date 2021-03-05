/// @function GMFMOD_Studio_EventInstance([handle]: int)
/// @param {int} handle (optional) default: pointer_null. You can assign this value later via assign function.
function GMFMOD_Studio_EventInstance(_handle) constructor
{
	inst_ = pointer_null; 
	
	static assign = function(handle)
	{
		var inst = GMFMOD_Ptr(handle);
		if (fmod_studio_evinst_is_valid(inst))
		{
			if (inst_ != pointer_null) // clean up first
				release();
			inst_ = inst;
		}
		else
		{
			show_debug_message("GMFMOD Error: Attempted to assign an invalid handle to " 
				+ "a " + instanceof(self) + " object!");	
		}
	};
	
	if (is_numeric(_handle))
	{
		assign(_handle);	
	}
	
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
	
	/// @function setPaused(paused: boolean)
	/// @description Sets the paused status of the event instance.
	/// @returns {number} 0 on success, -1 on error.
	static setPaused = function(paused)
	{
		return fmod_studio_evinst_set_paused(inst_, paused);	
	};
	
	/// @function getPitch()
	/// @returns {number} pitch multiplier
	static getPitch = function()
	{
		return fmod_studio_evinst_get_pitch(inst_);	
	};
	
	/// @function setPitch(multiplier: number)
	/// @returns {number} 0 on success, -1 on error.
	static setPitch = function(multiplier)
	{
		return fmod_studio_evinst_set_pitch(inst_, multiplier);	
	};
	
	/// @function get3DAttributes([_3D_attr]: GMFMOD_3D_ATTRIBUTES)
	/// @description Gets the current 3D attributes of this event instance. If no argument is provided, a new object will be created. 
	/// @param {GMFMOD_3D_ATTRIBUTES} _3D_attr (optional) 3D attributes object to populate with data.
	/// @returns {GMFMOD_3D_ATTRIBUTES} the 3D attributes object
	static get3DAttributes = function(_3D_attr)
	{
		var buf = GMFMOD_GetBuffer();
		fmod_studio_evinst_get_3D_attributes(inst_, buf.getAddress());
		
		if (instanceof(_3D_attr) == "GMFMOD_3D_ATTRIBUTES")
		{
			_3D_attr.readFromBuffer(buf);
		}
		else
		{
			_3D_attr = new GMFMOD_3D_ATTRIBUTES(buf);
		}
		
		return _3D_attr;
	};
	
	/// @function set3DAttributes(_3D_attr: GMFMOD_3D_ATTRIBUTES)
	/// @returns {void}
	static set3DAttributes = function(_3D_attr)
	{
		var buf = GMFMOD_GetBuffer();
		_3D_attr.writeToBuffer(buf);
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
	
	// Only relevant in Logging builds of FMOD Studio. Release builds will output 0 for all numbers.
	static getMemoryUsage = function(mem_usage)
	{
		var buf = GMFMOD_GetBuffer();
		var success = fmod_studio_evinst_get_memory_usage(inst_, buf.getAddress());
		
		mem_usage.readFromBuffer(buf);
		
		return success;
	};
	
	static getDescription = function()
	{
		var handle = fmod_studio_evinst_get_description(inst_);
		return new GMFMOD_Studio_EventDescription(handle);
	};
	
	static setCallback = function(callback_mask)
	{
		return fmod_studio_evinst_set_callback(inst_, callback_mask);	
	};
	
	static setCallbackAudioTable = function(studio)
	{
		return fmod_studio_evinst_set_callback_audiotable(inst_, studio);	
	};
	
	static getHandle = function()
	{
		return inst_;	
	};
}
