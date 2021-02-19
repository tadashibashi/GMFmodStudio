function FmodStudioEventDescription(_handle) constructor
{
	desc_ = FmodHandleToPtr(_handle); /// @is {pointer}
	
	static createInstance = function()
	{
		var evinst = fmod_studio_evdesc_create_instance(desc_);
		if (evinst == 0) {
			throw "FMOD Studio error: " + fmod_studio_get_error_string();	
		}
		
		return new FmodStudioEventInstance(evinst);
	};
	
	static getInstanceCount = function()
	{
		return fmod_studio_evdesc_get_instance_count(desc_);	
	}
	
	static getInstanceList = function(arr/*: Array<FmodStudioEventInstance>*/)
	{
		var buf/*: FmodBuffer*/ = FmodGetBuffer();
		var count = fmod_studio_evdesc_get_instance_list(desc_, buf.getSize()/8, buf.getAddress());
		array_resize(arr, count);
		
		for (var i = 0; i < count; ++i)
		{
			arr[@i] = new FmodStudioEventInstance(buf.read(buffer_u64));
		}
		
		return count;
	}
	
	// Returns a FmodGUID struct for future reference
	static getID = function()
	{
		var buf = FmodGetBuffer();
		fmod_studio_evdesc_get_id(desc_, buf.getAddress());
		
		var guid = new FmodGUID();
		guid.assignFromBuffer(buf);
		
		return guid;
	};
	
	static getParameterDescriptionByName = function(name)
	{
		var buf = FmodGetBuffer();
		
		if (fmod_studio_evdesc_get_paramdesc_by_name(desc_, name, buf.getAddress()) == 0)
		{
				var param/*: FmodStudioParameterDescription*/ = new FmodStudioParameterDescription();
				param.assignFromBuffer(buf);
				
				return param;
		}
		else
		{
			throw "Error getting Fmod Parameter Description: " + fmod_studio_get_error_string();	
		}
	};
	
	static getParameterDescriptionByIndex = function(index/*: int*/)
	{
		var buf/*: FmodBuffer*/ = FmodGetBuffer();
		if (fmod_studio_evdesc_get_paramdesc_by_index(desc_, index, 
			buf.getAddress()) == 0)
		{
			var param/*: FmodStudioParameterDescription*/ = 
				new FmodStudioParameterDescription();
			param.assignFromBuffer(buf);
			return param;
		}
		else
		{
			throw "Error getting Fmod Parameter Description: " + fmod_studio_get_error_string();
		}
	};
	
	static getParameterDescriptionByID = function(paramID/*: FmodStudioParameterID*/)
	{
		var buf/*: FmodBuffer*/ = FmodGetBuffer();
		paramID.sendToBuffer(buf);
		
		if (fmod_studio_evdesc_get_paramdesc_by_id(desc_, buf.getAddress()) == 0)
		{
			buf.seekReset();
			var param/*: FmodStudioParameterDescription*/ = 
				new FmodStudioParameterDescription();
			param.assignFromBuffer(buf);
			return param;
		}
		else
		{
			throw "Error getting Fmod Parameter Description: " + fmod_studio_get_error_string();
		}
	};

	
	static getUserProperty = function(name)
	{
		var buf/*: FmodBuffer*/ = FmodGetBuffer();
		fmod_studio_evdesc_get_user_property(desc_, name, buf.getAddress());
		
		var prop = new FmodStudioUserProperty();
		prop.assignFromBuffer(buf);
		
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
