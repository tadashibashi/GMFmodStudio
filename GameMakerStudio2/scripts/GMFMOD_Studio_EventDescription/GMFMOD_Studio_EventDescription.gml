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
				+ "a " + instanceof(self) + " object!");
	};
	
	if (argument_count == 1 && is_real(argument[0]))
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
	
	static getInstanceList = function(arr/*: Array<GMFMOD_Studio_EventInstance>*/)
	{	
		var buf/*: GMFMOD_Buffer*/ = GMFMOD_GetBuffer();
		var count = fmod_studio_evdesc_get_instance_count(desc_);
		buf.allocate(count * 8); // allow 8 bytes per pointer
		
		fmod_studio_evdesc_get_instance_list(desc_, buf.getSize()/8, buf.getAddress());

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
	
	// Returns a GMFMOD_GUID struct for future reference
	static getID = function()
	{
		var buf = GMFMOD_GetBuffer();
		fmod_studio_evdesc_get_id(desc_, buf.getAddress());
		
		var guid = new GMFMOD_GUID();
		guid.readFromBuffer(buf);
		
		return guid;
	};
	
	static getParamDescByName = function(name)
	{
		var buf = GMFMOD_GetBuffer();
		
		if (fmod_studio_evdesc_get_paramdesc_by_name(desc_, name, buf.getAddress()) == 0)
		{
				var param/*: GMFMOD_STUDIO_PARAMETER_DESCRIPTION*/ = new GMFMOD_STUDIO_PARAMETER_DESCRIPTION();
				param.readFromBuffer(buf);
				
				return param;
		}
		else
		{
			throw "Error getting Fmod Parameter Description: " + GMFMOD_GetErrorString();	
		}
	};
	
	/// @param {int} index
	static getParameterDescriptionByIndex = function(index)
	{
		var buf/*: GMFMOD_Buffer*/ = GMFMOD_GetBuffer();
		if (fmod_studio_evdesc_get_paramdesc_by_index(desc_, index, 
			buf.getAddress()) == 0)
		{
			var param/*: GMFMOD_STUDIO_PARAMETER_DESCRIPTION*/ = 
				new GMFMOD_STUDIO_PARAMETER_DESCRIPTION();
			param.readFromBuffer(buf);
			return param;
		}
		else
		{
			throw "Error getting Fmod Parameter Description: " + GMFMOD_GetErrorString();
		}
		
	};
	
	static getParamDescByID = function(paramID/*: GMFMOD_STUDIO_PARAMETER_ID*/)
	{
		var buf/*: GMFMOD_Buffer*/ = GMFMOD_GetBuffer();
		paramID.writeToBuffer(buf);
		
		if (fmod_studio_evdesc_get_paramdesc_by_id(desc_, buf.getAddress()) == 0)
		{
			buf.seekReset();
			var param/*: GMFMOD_STUDIO_PARAMETER_DESCRIPTION*/ = 
				new GMFMOD_STUDIO_PARAMETER_DESCRIPTION();
			param.readFromBuffer(buf);
			return param;
		}
		else
		{
			throw "Error getting Fmod Parameter Description: " + GMFMOD_GetErrorString();
		}
	};

	
	static getUserProperty = function(name)
	{
		var buf/*: GMFMOD_Buffer*/ = GMFMOD_GetBuffer();
		fmod_studio_evdesc_get_user_property(desc_, name, buf.getAddress());
		
		var prop = new GMFMOD_STUDIO_USER_PROPERTY();
		prop.readFromBuffer(buf);
		
		return prop;
	};
	
	// Returns the raw pointer to the EventDescription object
	static getHandle = function()
	{
		return desc_;	
	};
	
	// Compare if EventDescription contains the same FMOD event.
	static isEqualTo = function(event_desc)
	{
		return desc_ == event_desc.desc_;
	};
}

/// @hint 
