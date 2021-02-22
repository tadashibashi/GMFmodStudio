/// @function gmfs_assert(actual, expected, testname)
/// @description Test to help ensure software functionality
/// @param {any} actual
/// @param {any} expected
/// @param {string} testname
function gmfs_assert(actual, expected, testname)
{
	if (actual == expected)
	{
		show_debug_message("[" + testname + "] PASSED.");	
	}
	else
	{
		show_debug_message("[" + testname + "] FAILED! Expected " + string(expected) +
			", but got " + string(actual));
	}
}
