/// @param {int} index Listener index
/// @param {GMFMOD_Studio_System} studiosystem
function GMFMOD_Listener(_index, _studiosystem) : GMFMOD_3DObject() constructor
{
	index = _index;                    /// @is {int}
	studiosystem = _studiosystem;      /// @is {GMFMOD_Studio_System}
	
	/// @returns {void}
	static update = function()
	{
		studiosystem.setListenerAttributes(index, attr);
	};
}
