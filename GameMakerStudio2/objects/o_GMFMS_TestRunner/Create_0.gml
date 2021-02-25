/// @description Insert description here
// You can write your code in this editor

currentTest = 0;
tests = [];
currentProgress = 0;

window_width = 800;
window_height = 200;
color_shift = 0;

function runNextTest(obj_index)
{
	with (obj_index) instance_destroy();
	
	currentTest++;
	
	if (currentTest >= array_length(tests))
	{
		show_debug_message("Test Runner has completed all its tests!");	
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

runTests([
	o_GMFMS_Test_StudioSystem, 
	o_GMFMS_Test_EventDescription,
	o_GMFMS_Test_EventInstance]);