/// @function GMFMS_Assert(actual, expected, testname)
/// @description Test to help ensure software functionality
/// @param {any} actual
/// @param {any} expected
/// @param {string} testname
function GMFMS_Assert(actual, expected, testname)
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

function GMFMS_Performance() constructor
{
	tests = {};
	
	static start = function(name)
	{
		if (name == undefined)
		{
			tests.__default = get_timer();		
		}
		else
		{
			variable_struct_set(tests, name, get_timer());
		}
	};
	
	static stop = function(name)
	{
		if (name == undefined)
		{
			show_debug_message("Test took " + string((get_timer() - tests.__default) * 0.001) + "ms");	
		}
		else
		{
			show_debug_message("[" + name +"] took: " + string((get_timer() - variable_struct_get(tests, name)) * 0.001) + "ms");	
			variable_struct_remove(tests, name);
		}
	};
}

function GMFMS_Test(_name, _tests) constructor
{
	name = _name;
	tests = _tests;
	currentTest = 0;
	studio = pointer_null;
	currentTestObj = noone;
	hasstarted = false;
	
	static resetTests = function()
	{
		endLastTest();
		
		currentTest = 0;
		
		startTest();
	};
	
	static startTest = function()
	{
		if (studio != pointer_null)
			endLastTest();
		

		
		studio = GMFMS_HandleToPtr(fmod_studio_system_create());
		fmod_studio_system_initialize(studio, 1024, FMOD_STUDIO_INIT_NORMAL, 0);
		
		currentTestObj = instance_create_depth(0, 0, 0, tests[currentTest]);
		currentTestObj.studio = studio;
		
		if (!hasstarted) hasstarted = true;
		
		currentTest++;
	};
	
	static endLastTest = function()
	{
		if (currentTestObj != noone)
		{
			instance_destroy(currentTestObj);
			currentTestObj = noone;
		}
		
		if (studio != pointer_null)
		{
			fmod_studio_system_flush_commands(studio);
			fmod_studio_system_unload_all(studio);
			fmod_studio_system_release(studio);
			
			studio = pointer_null;
		}
	};
	
	static runNextTest = function()
	{	
		endLastTest();
		
		if (currentTest >= array_length(tests))
		{
			show_message("Tests for " + string(name) + " Finished!");
			endLastTest();
			return 1;
		}
		
		startTest();
		
		return 0;
	};

}
