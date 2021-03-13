/// @file Lightweight wrapper for an FMOD::Studio::EventDescription object

/// @struct GMFMOD_Studio_EventDescription([handle]: int)
/// @param {number} [handle]
function GMFMOD_Studio_EventDescription() constructor
{
	desc_ = pointer_null; /// @is {pointer}
	
	static assign = function(handle)
	{
		var desc = /*#cast*/ GMFMOD_Ptr(handle);
		if (fmod_studio_evdesc_is_valid(desc))
			desc_ = desc;
		else
			show_debug_message("GMFMOD Error: Attempted to assign an invalid handle to " 
				+ "a " + string(instanceof(self)) + " object!");
	};
	
	if (argument_count == 1 && is_numeric(argument[0]))
	{
		assign(argument[0]);	
	}
	
	/// @function createInstance([inst]: GMFMOD_Studio_EventInstance)
	/// @param {GMFMOD_Studio_EventInstance} [evinst] (optional). If not provided, a new GMFMOD_Studio_EventInstance object will be created and returned.
	/// @returns {GMFMOD_Studio_EventInstance}
	static createInstance = function(evinst)
	{
		// Create new instance and get the real handle
		var inst_handle = fmod_studio_evdesc_create_instance(desc_);

		// Wrap instance handle in GMFMS object
		if (instanceof(evinst) == "GMFMOD_Studio_EventInstance")    // use provided instance struct
			return evinst.assign(inst_handle);
		else                                       // create new instance struct
			return new GMFMOD_Studio_EventInstance(inst_handle); 
	};
	
	static getInstanceCount = function()
	{
		return fmod_studio_evdesc_get_instance_count(desc_);	
	};
	
	/// @param {Array<GMFMOD_Studio_EventInstance>} [arr] Optional if desiring to 
	///  populate your own array. If omitted, this function will return a new one.
	/// @returns {Array<GMFMOD_Studio_EventInstance>}
	static getInstanceList = function(arr)
	{	
		var buf/*: GMFMOD_Buffer*/ = GMFMOD_GetBuffer();
		var count = fmod_studio_evdesc_get_instance_count(desc_);
		buf.allocate(count * 8); // allow 8 bytes per pointer
		
		fmod_studio_evdesc_get_instance_list(desc_, count, buf.getAddress());

		if (GMFMOD_GetError() == FMOD_OK)
		{
			if (is_array(arr))  // Array provided, modify this one.
			{
				array_resize(arr, count);
			}
			else                // Array not provided, create a new one.
			{
				arr = array_create(count);
			}
			
			for (var i = 0; i < count; ++i)
			{
					arr[@i] = new GMFMOD_Studio_EventInstance(buf.read(buffer_u64));
			}
		}
		else
		{
			arr = [];	
		}

		return arr;
	};
	
	/// @returns {void}
	static releaseAllInstances = function()
	{
		fmod_studio_evdesc_release_all_instances(desc_);	
	};
	
// ============================================================================
// Sample Data
// ============================================================================
	
	/// @returns {void}	
	static loadSampleData = function()
	{
		fmod_studio_evdesc_load_sample_data(desc_);	
	};
	
	/// @returns {void}
	static unloadSampleData = function()
	{
		fmod_studio_evdesc_unload_sample_data(desc_);
	};
	
	/// @returns {number} loading state of samples value from (FMOD_STUDIO_LOADING_STATE_*) constants
	static getSampleLoadingState = function()
	{
		return fmod_studio_evdesc_get_sample_loading_state(desc_);	
	};
	
// ============================================================================
// Attributes
// ============================================================================
	
	/// @returns {bool}
	static is3D = function()
	{
		return fmod_studio_evdesc_is_3D(desc_);	
	};
	
	/// @returns {bool}
	static isOneshot = function()
	{
		return fmod_studio_evdesc_is_oneshot(desc_);	
	};
	
	/// @returns {bool}
	static isSnapshot = function()
	{
		return fmod_studio_evdesc_is_snapshot(desc_);	
	};
	
	/// @returns {bool}
	static isStream = function()
	{
		return fmod_studio_evdesc_is_stream(desc_);	
	};
	
	/// @returns {bool}
	static hasCue = function()
	{
		return fmod_studio_evdesc_has_cue(desc_);	
	};
	
	/// @returns {number}	
	static getMaxDistance = function()
	{
		return fmod_studio_evdesc_get_max_distance(desc_);	
	};
	
	/// @returns {number}
	static getMinDistance = function()
	{
		return fmod_studio_evdesc_get_min_distance(desc_);	
	};
	
	/// @returns {number} the sound size for 3D panning, which is the largest 
	///                   among all spatializers on the event's master track.
	static getSoundSize = function()
	{
		return fmod_studio_evdesc_get_sound_size(desc_);	
	};
	
// ============================================================================
// Parameters
// ============================================================================
	/// @returns {number} the number of parameter descriptions
	static getParameterDescriptionCount = function()
	{
		return fmod_studio_evdesc_get_paramdesc_count(desc_);	
	}
	
	/// @param {string} name parameter name
	/// @param {GMFMOD_STUDIO_PARAMETER_DESCRIPTION} [param] (optional) if you want to supply your own object
	static getParameterDescriptionByName = function(name, param)
	{
		var buf = GMFMOD_GetBuffer();
		
		fmod_studio_evdesc_get_paramdesc_by_name(desc_, name, buf.getAddress());
		
		if (GMFMOD_GetError() == FMOD_OK)
		{
			if (instanceof(param) != "GMFMOD_STUDIO_PARAMETER_DESCRIPTION")
				param = new GMFMOD_STUDIO_PARAMETER_DESCRIPTION();
			param.readFromBuffer(buf);
		}
		else
		{
			throw "GMFMOD Error getting Fmod Parameter Description: " + GMFMOD_GetErrorString();	
		}
		
		return param;
	};
	
	
	/// @param {number} index
	/// @param {GMFMOD_STUDIO_PARAMETER_DESCRIPTION} [paramdesc] (optional) if you want to provide your own object to assign values to
	static getParameterDescriptionByIndex = function(index, paramdesc)
	{
		var buf = GMFMOD_GetBuffer();
		fmod_studio_evdesc_get_paramdesc_by_index(desc_, index, buf.getAddress());
		
		if (instanceof(paramdesc) != "GMFMOD_STUDIO_PARAMETER_DESCRIPTION")
			paramdesc = new GMFMOD_STUDIO_PARAMETER_DESCRIPTION();
		paramdesc.readFromBuffer(buf);
		
		return paramdesc;
	};
	
	
	/// @param {GMFMOD_STUDIO_PARAMETER_ID} paramID
	/// @param {GMFMOD_STUDIO_PARAMETER_DESCRIPTION} [paramdesc] (optional) if you want to provide your own object to assign values to
	static getParameterDescriptionByID = function(paramID, paramdesc)
	{
		var buf = GMFMOD_GetBuffer();
		paramID.writeToBuffer(buf);
		
		fmod_studio_evdesc_get_paramdesc_by_id(desc_, buf.getAddress());
		buf.seekReset();
		
		if (instanceof(paramdesc) != "GMFMOD_STUDIO_PARAMETER_DESCRIPTION")
			paramdesc = new GMFMOD_STUDIO_PARAMETER_DESCRIPTION();
		paramdesc.readFromBuffer(buf);
		
		return paramdesc;
	};
	
// ============================================================================
// User Properties
// ============================================================================

	/// @param {string} name
	/// @param {GMFMOD_STUDIO_USER_PROPERTY} [userprop] (optional) if you want to provide your own object to assign values to
	static getUserProperty = function(name, userprop)
	{
		var buf = GMFMOD_GetBuffer();
		fmod_studio_evdesc_get_user_property(desc_, name, buf.getAddress());
		
		if (instanceof(userprop) != "GMFMOD_STUDIO_USER_PROPERTY")
			userprop = new GMFMOD_STUDIO_USER_PROPERTY();
		userprop.readFromBuffer(buf);
		
		return userprop;
	};
	
	
	/// @param {number} index
	/// @param {GMFMOD_STUDIO_USER_PROPERTY} [userprop] (optional) if you want to provide your own object to assign values to
	static getUserPropertyByIndex = function(index, userprop)
	{
		var buf = GMFMOD_GetBuffer();
		fmod_studio_evdesc_get_user_property_by_index(desc_, index, buf.getAddress());
		
		if (instanceof(userprop) != "GMFMOD_STUDIO_USER_PROPERTY")
			userprop = new GMFMOD_STUDIO_USER_PROPERTY();
		userprop.readFromBuffer(buf);
		
		return userprop;
	};
	
	/// @returns {number}
	static getUserPropertyCount = function()
	{
		return fmod_studio_evdesc_get_user_property_count(desc_);	
	};
	
// ============================================================================
// General
// ============================================================================
	
	/// @returns {number}
	static getLength = function()
	{
		return fmod_studio_evdesc_get_length(desc_);	
	};
	
	
	/// @param {GMFMOD_GUID} [guid] (optional) if you want to provide your own object to assign values to
	/// @returns {GMFMOD_GUID} id of the event description 
	static getID = function(guid)
	{
		var buf = GMFMOD_GetBuffer();
		fmod_studio_evdesc_get_id(desc_, buf.getAddress());
		
		if (instanceof(guid) != "GMFMOD_GUID")
			guid = new GMFMOD_GUID();
		guid.readFromBuffer(buf);
		
		return guid;
	};
	
	
	/// @param {int} callbackmask flags from FMOD_STUDIO_EVENT_CALLBACK_* constants
	/// @returns {void}
	static setCallback = function(callbackmask)
	{
		fmod_studio_evdesc_set_callback(desc_, callbackmask);	
	};

	
	/// @returns {string}
	static getPath = function()
	{
		return fmod_studio_evdesc_get_path(desc_);	
	};
	
	
	/// @returns {bool}
	static isValid = function()
	{
		return fmod_studio_evdesc_is_valid(desc_);	
	};
	
	
	// Returns the raw pointer to the EventDescription object
	/// @returns {pointer}
	static getHandle = function()
	{
		return desc_;	
	};
	
	
	// Compare if EventDescription contains the same FMOD event.
	/// @returns {bool}
	static isEqualTo = function(event_desc)
	{
		return (desc_ == event_desc.desc_);
	};
}

/// @hint GMFMOD_Studio_EventDescription:getLength()->number Gets the length of the event in milliseconds
/// @hint GMFMOD_Studio_EventDescription:getID([guid]: GMFMOD_GUID)->GMFMOD_GUID Gets the events GUID