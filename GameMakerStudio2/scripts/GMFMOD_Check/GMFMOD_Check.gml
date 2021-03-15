/// @function           GMFMOD_Check([testname])
/// @param    {string}  [testname:string] The name of the test
/// @returns  {void}
function GMFMOD_Check(testname)
{
	/// @description     Checks the latest FMOD function result, and logs an explanation of any errors to the console.
	if (GMFMOD_GetError() != FMOD_OK)
	{
		if (testname != undefined)
		{
			show_debug_message("===>>> FMOD Studio ERROR [" + string(testname) + "]: " 
				+ GMFMOD_GetErrorString());
			
		}
		else
		{
			show_debug_message("FMOD Studio ERROR: " + GMFMOD_GetErrorString());
		}
	}
	else
	{
		show_debug_message("[" + string(testname) + "] Passed.");
	}
}
