function GMFMOD_EventEmitter() : GMFMOD_3DObject() constructor
{
	gameObject = noone;
	eventInsts = [];
	
	static attatchToGameObject = function(objID)
	{
		if (is_numeric(objID))
		{
			gameObject = objID;
		}
	};
	
	static detatchFromGameObject = function()
	{
		gameObject = noone;	
	};
	
	static update = function()
	{
		// Grab position from gameObject if there is one attached
		if (gameObject != noone)
		{
			attr.position.x = gameObject.x;
			attr.position.y = gameObject.y;
		
			if (variable_instance_exists(gameObject, "z"))
			{
				attr.position.z = gameObject.z;
			}
		}

		
		// Update the 3D positional attributes of each event contained in this emitter
		var len = array_length(eventInsts);
		for (var i = 0; i < len; ++i)
		{
			var inst = eventInsts[i];
			inst.set3DAttributes(attr);
		}
	};
}