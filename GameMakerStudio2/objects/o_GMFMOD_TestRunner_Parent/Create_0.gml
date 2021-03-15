/// @description Insert description here
// You can write your code in this editor

// Reset Global Test Counter
global.__GMFMS_test_count = 0;
global.__GMFMS_success_count = 0;

currentTest = 0;
tests = [];
currentProgress = 0;

window_width = 800;
window_height = 200;
color_shift = 0;
finished = false;

function runNextTest(obj_index)
{
	with (obj_index) instance_destroy();
	
	currentTest++;
	
	if (currentTest >= array_length(tests))
	{
		show_debug_message("Test Runner has completed all its tests!");	
		finished = true;
	}
	else
	{
		show_debug_message("o=============================================================o");
		show_debug_message("|                                                             |");
		show_debug_message("  Starting Test: " + object_get_name(tests[currentTest]));
		show_debug_message("|                                                             |");
		show_debug_message("o=============================================================o");
		var testObj = instance_create_depth(0, 0, 0, tests[currentTest]);
		testObj.addFinishListener(runNextTest);
	}
}

function runTests(_tests)
{
	if (!is_array(_tests))
		throw "Invalid parameter. TestRunner runTests param must be an array of test object indices";
		
	tests = _tests;
	if (array_length(tests) > 0)
	{
		show_debug_message("o=============================================================o");
		show_debug_message("|                                                             |");
		show_debug_message("  Starting Test: " + object_get_name(tests[currentTest]));
		show_debug_message("|                                                             |");
		show_debug_message("o=============================================================o");
		var testObj = instance_create_depth(0, 0, 0, tests[0]);
		testObj.addFinishListener(runNextTest);
	}
}
