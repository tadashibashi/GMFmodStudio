/// @file Lightweight wrapper for an FMOD::Studio::EventDescription object

/// @struct GMFMOD_Studio_EventDescription([handle]: int)
/// @param {number} [handle]
function GMFMOD_Studio_EventDescription() constructor
{
	desc_ = pointer_null; /// @is {pointer}
	
	// Takes a double and converts it to a ptr, assigning it to the internal handle.
	
	static assign = function(handle)
	{
		desc_ = /*#cast*/ GMFMOD_Ptr(handle);
	};
	
	if (argument_count == 1 && is_real(argument[0]))
	{
		assign(argument[0]);	
	}
	
	/// @function createInstance([inst]: GMFMS_EvInst)
	/// @param {GMFMS_EvInst} [evinst] (optional). If not provided, a new GMFMS_EvInst object will be created and returned.
	static createInstance = function(evinst)
	{
		// Create new instance and get the real handle
		var inst_handle = fmod_studio_evdesc_create_instance(desc_);

		// Wrap instance handle in GMFMS object
		if (instanceof(evinst) == "GMFMS_EvInst")    // use provided instance struct
			return evinst.assign(inst_handle);
		else                                       // create new instance struct
			return new GMFMS_EvInst(inst_handle); 
	};
	
	static getInstanceCount = function()
	{
		return fmod_studio_evdesc_get_instance_count(desc_);	
	};
	
	static getInstanceList = function(arr/*: Array<GMFMS_EvInst>*/)
	{
		var buf/*: GMFMOD_Buffer*/ = GMFMOD_GetBuffer();
		var count = fmod_studio_evdesc_get_instance_list(desc_, buf.getSize()/8, buf.getAddress());
		
		if (is_array(arr))  // Array provided, modify this one.
		{
			array_resize(arr, count);
		
			for (var i = 0; i < count; ++i)
			{
				arr[@i] = new GMFMS_EvInst(buf.read(buffer_u64));
			}
		}
		else                   // Array not provided, create a new one.
		{
			arr = array_create(count);
		}

		
		return arr;
	}
	
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
