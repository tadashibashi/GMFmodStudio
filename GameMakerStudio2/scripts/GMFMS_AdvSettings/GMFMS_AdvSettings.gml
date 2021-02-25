/// @file A GML representation of the FMOD_STUDIO_ADVANCED_SETTINGS struct.
/// Contains helper functions to manage buffer transfer to and from the 
/// GMFmodStudio extension.
/// Advanced settings are set before the FMOD Studio System object is 
/// initialized to configure memory and streaming settings.
/// @copyright Aaron Ishibashi, 2021.

/// @struct GMFMS_AdvSettings([buffer: GMFMS_Buffer])
/// @param {GMFMS_Buffer} [buffer] (optional) Buffer to initialize data from.
///
function GMFMS_AdvSettings() constructor
{
	// ===== Initialization ======================================================

	commandqueuesize = -1;        /// @is {int} uint_32_t
	handleinitialsize = -1;       /// @is {int} uint_32_t
	studioupdateperiod = -1;      /// @is {int} int_32_t
	idlesampledatapoolsize = -1;  /// @is {int} int32_t
	streamingscheduledelay = -1;  /// @is {int} uint_32_t
	encryptionkey = "";           /// @is {string}
	// ---------------------------------------------------------------------------
	
	/// @function readFromBuffer(buf: GMFMS_Buffer)->void
	/// @param {GMFMS_Buffer} buf
	/// @description Populates this object with the contents form a buffer.
	/// @returns {void}
	static readFromBuffer = function(buf)
	{
		commandqueuesize = buf.read(buffer_u32);
		handleinitialsize = buf.read(buffer_u32);
		studioupdateperiod = buf.read(buffer_s32);
		idlesampledatapoolsize = buf.read(buffer_s32);
		streamingscheduledelay = buf.read(buffer_u32);
		encryptionkey = buf.read(buffer_string);
	};
	
	// Optional initialization via a buffer.
	if (argument_count == 1 && instanceof(argument[0]) == "GMFMS_Buffer")
	{
		readFromBuffer(argument[0]);
	}
	
	/// @function writeToBuffer(buf: GMFMS_Buffer)->void
	/// @param {GMFMS_Buffer} buf
	///
	/// @description Writes this object's internal data to a buffer.
	/// @returns {void}
	static writeToBuffer = function(buf)
	{
		buf.write(buffer_u32, commandqueuesize);
		buf.write(buffer_u32, handleinitialsize);
		buf.write(buffer_s32, studioupdateperiod);
		buf.write(buffer_s32, idlesampledatapoolsize);
		buf.write(buffer_u32, streamingscheduledelay);
		buf.write(buffer_string, encryptionkey);
	};
	
	/// @function log()->void
	///
	/// @description Logs this object's internal data to the console.
	/// @returns {void}
	static log = function()
	{
		show_debug_message("===== GMFMS_AdvSettings Log =====");	
		show_debug_message("commandqueuesize: " + string(commandqueuesize));	
		show_debug_message("handleinitialsize: " + string(handleinitialsize));	
		show_debug_message("studioupdateperiod: " + string(studioupdateperiod));	
		show_debug_message("idlesampledatapoolsize: " + string(idlesampledatapoolsize));	
		show_debug_message("streamingscheduledelay: " + string(streamingscheduledelay));	
		show_debug_message("encryptionkey: " + encryptionkey);	
	};
}

// GMEdit Hints ===============================================================
/// @hint GMFMS_AdvSettings:readFromBuffer(buf: GMFMS_Buffer)->void Reads data from a buffer and assigns it to this struct.
/// @hint GMFMS_AdvSettings:writeToBuffer(buf: GMFMS_Buffer)->void Writes the data from this struct into a buffer.
/// @hint GMFMS_AdvSettings:log()->void Logs this object's data to the console.
