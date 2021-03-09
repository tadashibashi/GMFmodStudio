/// @struct GMFMOD_PerformanceTester()
function GMFMOD_PerformanceTester() constructor
{
	/// @description     This object tracks the performance time of your code and logs it to 
    ///                  the console.
    ///                  Set up tests using "start", indicating the name of the test, and end the
    ///                  time check with "stop", also indicating that same name.
	
	
	// ===== Initialization =====================================================
	
	tests = {};
	// ---------------------------------------------------------------------------
	
	/// @func start([name: string])->void
	/// @param {string} name (optional) Name of the test to start.
	///
	/// @desc Starts a test.
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
	
	/// @func stop([name: string])->void
	/// @param {string} name (optional) Name of the test to stop.
	///
	/// @desc Ends a test and logs the time it took to the console. The name
	/// must match with the name you used in "start".
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
	
	static stopAllTests = function()
	{
		var names = variable_struct_get_names(self.tests);
		
	};
}

/// @hint GMFMOD_PerformanceTester:start([name: string])->void Starts a test.
/// @hint GMFMOD_PerformanceTester:stop([name: string])->void Starts a test.
