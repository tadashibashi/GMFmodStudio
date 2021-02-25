/// @function           GMFMS_Check([testname])
/// @param    {string}  [testname:string] The name of the test
/// @returns  {void}
function GMFMS_Check(testname)
{
	if (GMFMS_GetError() != FMOD_OK)
	{
		if (testname != undefined)
		{
			show_debug_message("FMOD Studio ERROR [" + string(testname) + "]: " 
				+ GMFMS_GetErrorString());
			
		}
		else
		{
			show_debug_message("FMOD Studio ERROR: " + GMFMS_GetErrorString());
		}
	}
	else
	{
		++global.__GMFMS_success_count;
	}
	
	++global.__GMFMS_test_count;
}
