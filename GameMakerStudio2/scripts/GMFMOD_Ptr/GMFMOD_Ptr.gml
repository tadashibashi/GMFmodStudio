/// @function                  GMFMOD_Ptr(handle)
/// @param    {number}  handle received from the GMFmodStudio extension
/// @returns  {pointer}        crossplatform retrieval of pointers to FMOD 
///	                           objects from extension
function GMFMOD_Ptr(handle)
{
	if (typeof(handle) == "struct") { // HTML5 behavior
		return handle;
	} else {                          // Windows
		return ptr(/*#cast*/ handle);
	}
}
