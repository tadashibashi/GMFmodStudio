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
		show_debug_message("[" + testname + "] PASSED.");
		++global.__GMFMS_success_count;
	}
	else
	{
		show_debug_message("=====>>>>> [" + testname + "] FAILED! Expected " + string(expected) +
			", but got " + string(actual));
	}
	
	++global.__GMFMS_test_count;
}
