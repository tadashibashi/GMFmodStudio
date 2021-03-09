global.__GMFMS_test_count = 0;
global.__GMFMS_success_count = 0;

/// @function          GMFMOD_Assert(actual: T, expected: T, testname: string)->void;
/// @template          T
/// @param   {T}       actual
/// @param   {T}       expected
/// @param   {string}  testname
/// @returns {void}
function GMFMOD_Assert(actual, expected, testname)
{
	/// @description    Compares actual value to the expected result. The results are logged to the console.
	
	if (actual == expected)
	{
		//show_debug_message("[" + testname + "] PASSED.");
		++global.__GMFMS_success_count;
	}
	else
	{
		show_debug_message("[" + testname + "] FAILED! Expected " + string(expected) +
			", but got " + string(actual));
	}
	
	++global.__GMFMS_test_count;
}

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
			show_debug_message("FMOD Studio ERROR [" + string(testname) + "]: " 
				+ GMFMOD_GetErrorString());
			
		}
		else
		{
			show_debug_message("FMOD Studio ERROR: " + GMFMOD_GetErrorString());
		}
	}
	else
	{
		++global.__GMFMS_success_count;
	}
	
	++global.__GMFMS_test_count;
}
