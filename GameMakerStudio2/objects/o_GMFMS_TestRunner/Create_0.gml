/// @description Insert description here
// You can write your code in this editor

currentTest = 0;
tests = [];

function runNextTest(obj_index)
{
	with (obj_index) instance_destroy();
	
	currentTest++;
	
	if (currentTest >= array_length(tests))
	{
		show_message("Test Runner has completed all its tests");	
	}
	else
	{
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
		var testObj = instance_create_depth(0, 0, 0, tests[0]);
		testObj.addFinishListener(runNextTest);	
	}
}

runTests([o_GMFMS_Test_PlayEvent]);