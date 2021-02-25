function GMFMS_Buffer(size, alignment) constructor
{
	// ===== "Private" ===========================================================
	buffer_ = buffer_create(size, buffer_fixed, alignment); /// @is {buffer}
	
	// ===== "Public" ============================================================
	
	/// @function         allocate(new_size)
	/// @param    {int}   new_size The size in bytes to set the buffer to.
	/// @returns  {void}
	static allocate = function(new_size)
	{
			/// @description    Allocates memory to the buffer. 
			///                 New size must be greater than current 
			///                 and otherwise will be ignored.
			
		var old_size = self.getSize();
		if (new_size > old_size)
		{
			var old_seek = buffer_tell(buffer_);
			var old_align = buffer_get_alignment(buffer_);
			
			var new_buf = buffer_create(new_size, buffer_fixed, old_align);
			
			// Copy old contents into new
			buffer_copy(buffer_, 0, old_size, new_buf, 0);
			
			// Delete old buffer and swap with new one.
			buffer_delete(buffer_);
			buffer_ = new_buf;
			
			// Seek to old position.
			buffer_seek(buffer_, buffer_seek_start, old_seek);
		}
	};
	
	
	
	
	/// @function getAlignment()
	/// @returns the alignment of the buffer.
	static getAlignment = function()
	{
		return buffer_get_alignment(buffer_);
	};
	
	
	
	
	/// @function       getSize()
	/// @returns {int}  The max size of the buffer in bytes
	static getSize = function()
	{
		/// @description   Calculates and returns the maximum size of the internal buffer.
		///                The current buffer position is maintained.
		
		var current_pos = buffer_tell(buffer_);
		buffer_seek(buffer_, buffer_seek_end, 0);
		var _size = buffer_tell(buffer_);
		buffer_seek(buffer_, buffer_seek_start, current_pos);
		
		return _size;
	};
	
	
	
	
	/// @function        seekReset()
	/// @returns  {void}
	static seekReset = function()
	{
		/// @description Resets the seek position to the buffer's starting point.
		
		buffer_seek(buffer_, buffer_seek_start, 0);	
	};
	
	
	
	
	/// @function tell()
	/// @returns {int} the current seek position.
	static tell = function()
	{
		/// @description Gets the current seek position of the buffer.
		
		return buffer_tell(buffer_);	
	};
	
	
	
	
	/// @function                 read(data_type)->
	/// @param    {buffer_type}   data_type  The data type to read.
	/// @returns  {string|number}
	static read = function(data_type)
	{
			/// @desc   Returns data of the indicated type from the buffer. 
			///         Moves the buffer position past that point according
			///         to its alignment.
			
		return buffer_read(buffer_, data_type);	
	};
	
	
	
	
	/// @function           readCharStar()->string
	/// @returns   {string}
	static readCharStar = function()
	{
		/// @description   Interprets a const char * from C++ code to a GML string.
		///                This is first received as a 64bit uint from the dll-side
	    ///				   and then copied into a GML string.
		
		var charPtr = buffer_read(buffer_, buffer_u64);  // grab the ptr from the buffer
		return GMFMS_InterpretString(charPtr);           // interpret char * back in DLL to GML string.
	};
	
	
	
	
	/// @function                  write(type, value)->void
	/// @param    {buffer_type}    type   The type of data to write
	/// @param    {string|number}  value  The data to write
	/// @returns  {void}
	static write = function(type, value)
	{
		/// @description   Writes data into the buffer and moves the buffer position past that point.
		
		buffer_write(buffer_, type, value);	
	};
	
	
	
	
	/// @function                    seek(base, bytes)
	/// @param    {buffer_seek_base} base   the base position to seek from
	/// @param    {int}              bytes  the bytes relative to the base position.
	/// @returns  {void}
	static seek = function(base, bytes)
	{
		/// @description   Moves the position of the head to the corresponding position.
		
		buffer_seek(buffer_, base, bytes);	
	};
	
	
	
	
	/// @function           getAddress()->pointer
	/// @returns  {pointer}
	static getAddress = function()
	{
		/// @description   Gets the buffer's starting address as a pointer to send 
		///                to a native extension. Make sure to call this when sending
		///                to the GMFmodStudio extension.
		return buffer_get_address(buffer_);	
	};
	
	
	
	
	/// @function         getBuffer()->buffer
	/// @returns {buffer} 
	static getBuffer = function()
	{
		/// @description Gets the internal GMS2 buffer index for debugging purposes.
		
		return buffer_;
	};
	
	
	
	
	/// @function       release()->void
	/// @returns {void}
	static release = function()
	{
		/// @description     Frees the buffer from memory. Use only when deleting this object
		
		buffer_delete(buffer_);	
	};
}

/// @hint new GMFMS_Buffer(size: int, alignment: int)->GMFMS_Buffer 
/// @hint GMFMS_Buffer:release()->void Frees the buffer from memory. Call this when deleting this object.
/// @hint GMFMS_Buffer:allocate(new_size: int)->void Allocates a new larger memory size.
/// @hint GMFMS_Buffer:read(type: buffer_type)->any Reads data from the buffer. Moves the read/write position.
/// @hint GMFMS_Buffer:readCharStar()->string Interprets a const C-string sent from an extension.
/// @hint GMFMS_Buffer:write(type: buffer_type, value: string|number)->void Write data into the buffer. Moves the read/write position.
/// @hint GMFMS_Buffer:seek(base: buffer_seek_base, bytes: int)->void Seek to a position within the buffer.
/// @hint GMFMS_Buffer:seekReset()->void Seek back to the buffer's start position.
/// @hint GMFMS_Buffer:tell()->int Tells the buffer's current read/write position.
/// @hint GMFMS_Buffer:getSize()->int Gets the max size of the buffer in bytes.
/// @hint GMFMS_Buffer:getAddress()->ptr Gets the address of this buffer.
/// @hint GMFMS_Buffer:getAlignment()->int Gets the buffer's byte alignment.
/// @hint GMFMS_Buffer:getBuffer()->buffer Gets the GameMaker Studio buffer.

/// @func GMFMS_GetBuffer()
/// @desc Gets the global buffer to be used for passing data back and forth between
/// game maker and the GMFmodStudio Extension.
/// @returns {GMFMS_Buffer} The global GMFMS_Buffer object
function GMFMS_GetBuffer()
{
	if (!variable_global_exists("__fmod_studio_extension_buffer"))
	{
		global.__fmod_studio_extension_buffer = new GMFMS_Buffer(256, 1);
	}
	
	global.__fmod_studio_extension_buffer.seekReset();
	
	return global.__fmod_studio_extension_buffer;
}

/// @function                  GMFMS_Ptr(handle)
/// @returns  {struct|pointer} Handles the conversion of pointers in HTML5/Windows
function GMFMS_Ptr(handle)
{
	if (typeof(handle) == "struct") { // HTML5 behavior
		return handle;
	} else {                          // Windows
		return ptr(handle);
	}
}
