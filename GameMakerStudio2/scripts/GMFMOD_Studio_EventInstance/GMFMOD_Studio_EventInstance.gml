/// @function GMFMOD_Studio_EventInstance([handle]: int)
/// @param {int} [handle] (optional) default: pointer_null. You can assign this value later via assign function.
function GMFMOD_Studio_EventInstance(_handle) constructor
{
	inst_ = pointer_null; /// @is {pointer} 
	
	static assign = function(handle)
	{
		var inst = GMFMOD_Ptr(handle);
		if (fmod_studio_evinst_is_valid(inst))
		{
			if (inst_ != pointer_null) // clean up first
			{
				stop(FMOD_STUDIO_STOP_IMMEDIATE);
				release();
			}
				
			inst_ = inst;
		}
		else
		{
			show_debug_message("GMFMOD Error: Attempted to assign an invalid handle to " 
				+ "a " + string(instanceof(self)) + " object!");	
		}
	};
	
	
// ============================================================================
// Playback Control
// ============================================================================
	/// @param {void}
	static start = function()
	{
		fmod_studio_evinst_start(inst_);	
	};
	
	
	/// @param {number} [mode] (default: FMOD_STUDIO_STOP_ALLOWFADEOUT)
	/// @param {void}
	static stop = function(mode)
	{
		if (mode == undefined) mode = FMOD_STUDIO_STOP_ALLOWFADEOUT;
		
		fmod_studio_evinst_stop(inst_, mode);	
	};
	
	
	/// @returns {number} from FMOD_STUDIO_PLAYBACK_* constants
	static getPlaybackState = function()
	{
		return fmod_studio_evinst_get_playback_state(inst_);	
	};
	
	
	/// @param {bool}
	static getPaused = function()
	{
		return fmod_studio_evinst_get_paused(inst_);	
	};
	

	/// @returns {void}
	static setPaused = function(paused)
	{
		fmod_studio_evinst_set_paused(inst_, paused);	
	};
	
	
	/// @returns {void}
	static triggerCue = function()
	{
		fmod_studio_evinst_trigger_cue(inst_);	
	};
	
	
// ============================================================================
// Playback Properties
// ============================================================================
	
	
	/// @function getPitch()
	/// @param {bool} [getfinalvalue] (default: false)
	/// @returns {number} pitch multiplier
	static getPitch = function(getfinalvalue)
	{
		if (getfinalvalue == undefined) getfinalvalue = false;
		
		if (getfinalvalue)
			return fmod_studio_evinst_get_pitch_final(inst_);
		else
			return fmod_studio_evinst_get_pitch(inst_);	
	};
	
	/// @function setPitch(multiplier: number)
	/// @returns {number} 0 on success, -1 on error.
	static setPitch = function(multiplier)
	{
		return fmod_studio_evinst_set_pitch(inst_, multiplier);	
	};
	
	/// @param   {number} propindex from FMOD_STUDIO_EVENT_PROPERTY_* constants
	/// @returns {void}
	static setProperty = function(propindex, value)
	{
		fmod_studio_evinst_set_property(inst_, propindex, value);
	};
	
	
	/// @param   {number} propindex from FMOD_STUDIO_EVENT_PROPERTY_* constants
	/// @returns {number}
	static getProperty = function(propindex)
	{
		return fmod_studio_evinst_get_property(inst_, propindex);	
	};
	
	
	/// @param   {number} timelinepos in milliseconds
	/// @returns {void}
	static setTimelinePosition = function(timelinepos)
	{
		fmod_studio_evinst_set_timeline_position(inst_, timelinspos);
	};
	
	
	/// @returns {number} timeline position in milliseconds
	static getTimelinePosition = function()
	{
		return fmod_studio_evinst_get_timeline_position(inst_);	
	};
	
	
	/// @param   {number} volume scale
	/// @returns {void}
	static setVolume = function(volume)
	{
		fmod_studio_evinst_set_volume(inst_, volume);	
	};
	
	
	/// @param   {bool} [getfinalvalue] (default: false)
	/// @returns {number} volume scale
	static getVolume = function(getfinalvalue)
	{
		if (getfinalvalue == undefined) getfinalvalue = false;
		
		if (getfinalvalue)
			return fmod_studio_evinst_get_volume_final(inst_);
		else
			return fmod_studio_evinst_get_volume(inst_);	
	};
	
	
	/// @returns {bool}
	static isVirtual = function()
	{
		return fmod_studio_evinst_is_virtual(inst_);
	}
	
	
// ============================================================================
// 3D Attributes
// ============================================================================
	
	
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
	
	
	/// @param   {number} listenermask
	/// @returns {void}
	static setListenerMask = function(listenermask)
	{
		fmod_studio_evinst_set_listener_mask(inst_, listenermask);
	};
	
	
	/// @returns {number} listenermask
	static getListenerMask = function()
	{
		return fmod_studio_evinst_get_listener_mask(inst_);	
	};
	
	
// ============================================================================
// Parameters
// ============================================================================
	/// @param {string} name
	/// @param {number} value
	/// @returns {void}
	static setParameterByName = function(name, value)
	{
		fmod_studio_evinst_set_parameter_by_name(inst_, name, value);
	};	
	
	
	/// @param {string} name
	/// @returns {number} parameter value
	static getParameterByName = function(name)
	{
		return fmod_studio_evinst_get_parameter_by_name(inst_, name);
	};
	
	
	/// @param {GMFMOD_STUDIO_PARAMETER_ID} pid
	/// @param {number}                     value
	/// @returns {void}
	static setParameterByID = function(pid, value)
	{
		var buf = GMFMOD_GetBuffer();
		pid.writeToBuffer(buf);
		fmod_studio_evinst_set_parameter_by_id(inst_, buf.getAddress(), value);
	};
	
	
	/// @param {string} name
	/// @param {bool}   [getfinalvalue] (default: false)
	/// @returns {number} parameter value
	static getParameterByID = function(pid, getfinalvalue)
	{
		var buf = GMFMOD_GetBuffer();
		pid.writeToBuffer(buf);
		
		if (getfinalvalue == undefined) getfinalvalue = false;
		
		if (getfinalvalue)
		{
			return fmod_studio_evinst_get_parameter_by_id_final(inst_, 
				buf.getAddress());
		}
		else
		{
			return fmod_studio_evinst_get_parameter_by_id(inst_, 
				buf.getAddress());
		}
	};
	
	
	/// @param   {array<GMFMOD_STUDIO_PARAMETER_ID>} parameterids
	/// @param   {array<number>}                     values       make sure each index corresponds to the index of the parameter ids array
	/// @param   {bool}                              [ignoreseek] (default: false)
	/// @returns {void}
	static setParametersByIDs = function(parameterids, values, ignoreseek)
	{
		var buf = GMFMOD_GetBuffer();
		var count = array_length(parameterids);
		for (var i = 0; i < count; ++i)
		{
			parameterids[i].writeToBuffer(buf);
			buf.write(buffer_f32, values[i]);
		}
		
		fmod_studio_evinst_set_parameters_by_ids(inst_, buf.getAddress(), count, 
			ignoreseek);
	};


// ============================================================================
// Core
// ============================================================================
	// Get channel group not yet supported!
	
	
	/// @param {number} reverbindex
	/// @param {number} level
	/// @returns {void}
	static setReverbLevel = function(reverbindex, level)
	{
		fmod_studio_evinst_set_reverb_level(inst_, reverbindex, level);	
	};
	
	
	/// @param {number} reverbindex
	/// @returns {void}
	static getReverbLevel = function(reverbindex)
	{
		return fmod_studio_evinst_get_reverb_level(inst_, reverbindex);	
	};
	
	
// ============================================================================
// Profiling
// ============================================================================	

	// Only relevant in Logging builds of FMOD Studio. Release builds will output 0 for all numbers.
	/// @param   {GMFMOD_STUDIO_MEMORY_USAGE} [memusage] (optional) to provide
	///               your own object to receive the data.
	/// @returns {GMFMOD_STUDIO_MEMORY_USAGE}
	static getMemoryUsage = function(memusage)
	{
		var buf = GMFMOD_GetBuffer();
		var success = fmod_studio_evinst_get_memory_usage(inst_, buf.getAddress());
		
		if (instanceof(memusage) == "GMFMOD_STUDIO_MEMORY_USAGE")
			memusage.readFromBuffer(buf);
		else
			memusage = new GMFMOD_STUDIO_MEMORY_USAGE(buf);
		
		return memusage;
	};
	
	/// @param   {bool} [exclusive] (default: true). False is inclusive.
	/// @returns {number} the num microseconds of time spent on processing this
	///                   unit last update.
	static getCPUUsage = function(exclusive)
	{
		if (exclusive == undefined) exclusive = true;
		
		if (exclusive)
			return fmod_studio_evinst_get_cpu_usage_exclusive(inst_);
		else
			return fmod_studio_evinst_get_cpu_usage_inclusive(inst_);
	}
	
	
	
	
// ============================================================================
// Callbacks
// ============================================================================	
	static setCallback = function(callback_mask)
	{
		return fmod_studio_evinst_set_callback(inst_, callback_mask);	
	};
	
	
	static setCallbackAudioTable = function(studio)
	{
		return fmod_studio_evinst_set_callback_audiotable(inst_, studio);	
	};
	
	
// ============================================================================
// General
// ============================================================================	
	/// @param {GMFMOD_Studio_EventDescription} [evdesc] (optional) to provide
	///             your own object to receive the data.
	/// @returns {GMFMOD_Studio_EventDescription}
	static getDescription = function(evdesc)
	{
		var handle = fmod_studio_evinst_get_description(inst_);
		
		if (instanceof(evdesc) == "GMFMOD_Studio_EventDescription")
			evdesc.assign(handle);
		else
			evdesc = new GMFMOD_Studio_EventDescription(handle);
		
		return evdesc;
	};

	
	/// @returns {void}
	static release = function()
	{
		fmod_studio_evinst_release(inst_);	
	};
	
	
	/// @returns {bool}
	static isValid = function()
	{
		return fmod_studio_evinst_is_valid(inst_);	
	};
	
	
	/// @returns {pointer}
	static getHandle = function()
	{
		return inst_;	
	};
	
	
	// Constructor initialization via handle
	if (is_numeric(_handle))
	{
		assign(_handle);	
	}
}
