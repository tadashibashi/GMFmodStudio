function GMFMOD_3DObject() constructor
{
	attr = new GMFMOD_3D_ATTRIBUTES(); /// @is {GMFMOD_3D_ATTRIBUTES}
	
	// Set default orientation (facing forward
	attr.forward.z = 1;
	attr.up.y = 1;
	
	/// @param {number} x
	/// @param {number} y
	/// @param {number} [z]
	/// @returns {GMFMOD_Listener2D} self
	static setPosition = function(_x, _y, _z)
	{
		attr.position.x = _x;
		attr.position.y = _y;
		
		if (_z != undefined)
			attr.position.z = _z;
		
		return self;
	};
	
	/// @param {number} x
	/// @param {number} y
	/// @param {number} [z]
	/// @returns {GMFMOD_Listener} self
	static setVelocity = function(_x, _y, _z)
	{
		attr.velocity.x = _x;
		attr.velocity.y = _y;
		
		if (_z != undefined)
			attr.velocity.z = _z;
			
		return self;
	};
	
	/// @param {number} x
	/// @param {number} y
	/// @param {number} [z]
	/// @returns {GMFMOD_Listener2D} self
	static setUp = function(_x, _y, _z)
	{
		attr.up.x = _x;
		attr.up.y = _y;
		
		if (_z != undefined)
			attr.up.z = _z;
		
		return self;
	};	
	
	/// @param {number} x
	/// @param {number} y
	/// @param {number} [z]
	/// @returns {GMFMOD_Listener2D} self
	static setForward = function(_x, _y, _z)
	{
		attr.forward.x = _x;
		attr.forward.y = _y;
		
		if (_z != undefined)
			attr.forward.z = _z;
		
		return self;
	};
	
	/// @returns {GMFMOD_VECTOR}
	static getPosition = function()
	{
		return attr.position;	
	};	
	
	/// @returns {GMFMOD_VECTOR}
	static getVelocity = function()
	{
		return attr.velocity;	
	};	
	
	/// @returns {GMFMOD_VECTOR}	
	static getUp = function()
	{
		return attr.up;	
	};
	
	/// @returns {GMFMOD_VECTOR}
	static getForward = function()
	{
		return attr.forward;	
	};
}