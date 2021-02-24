function GMFMS_Buffer(size, alignment) constructor
{
	// ===== "Private" ===========================================================
	buffer_ = buffer_create(size, buffer_fixed, alignment); /// @is {buffer}
	
	// ===== "Public" ============================================================
	/// @function getSize()
	/// @returns {int} the max size of the buffer in bytes.
	static getSize = function()
	{
		var current_pos = buffer_tell(buffer_);
		buffer_seek(buffer_, buffer_seek_end, 0);
		var _size = buffer_tell(buffer_);
		buffer_seek(buffer_, buffer_seek_start, current_pos);
		
		return _size;
	};
	
	/// @function allocate(new_size)
	/// @description Allocates memory to the buffer. New size must be greater than current and otherwise will be ignored.
	/// @param {int} new_size the size in bytes to set the buffer to.
	/// @returns {void}
	static allocate = function(new_size)
	{
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
	
	/// @function seekReset()
	/// @description Resets the seek position to the buffer starting point.
	/// @returns {void}
	static seekReset = function()
	{
		buffer_seek(buffer_, buffer_seek_start, 0);	
	};
	
	/// @function tell()
	/// @description Gets the current seek position of the buffer.
	/// @returns {int} the current seek position.
	static tell = function()
	{
		return buffer_tell(buffer_);	
	};
	
	/// @func read(data_type)
	/// @desc Returns a piece of data from the buffer and moves the head past that position.
	/// @param {buffer_type} data_type 
	static read = function(data_type)
	{
		return buffer_read(buffer_, data_type);	
	};
	
	/// @func readCharStar()
	/// @desc Interprets a const char * from C++ code to a GML string.
	/// @returns {string}
	static readCharStar = function()
	{
		// read the pointer (should convert to 64bit uint on dll-side)
		var charPtr = buffer_read(buffer_, buffer_u64);
		return GMFMS_InterpretString(charPtr);
	};
	
	/// @func write(data_type, value)
	/// @desc Writes data into the buffer and moves the head past that point.
	/// @param {buffer_type} type the type of data to write
	/// @param {any} value the data to write
	static write = function(type, value)
	{
		buffer_write(buffer_, type, value);	
	};
	
	/// @func seek(base_pos, rel_bytes)
	/// @desc Moves the position of the head to the corresponding position.
	/// @param base the base position to seek from
	/// @param {int} rel_bytes the bytes relative to the base position.
	static seek = function(base, rel_bytes)
	{
		buffer_seek(buffer_, base, rel_bytes);	
	};
	
	static getAddress = function()
	{
		return buffer_get_address(buffer_);	
	};
	
	static getBuffer = function()
	{
		return buffer_;
	};
	
	// Frees the buffer from memory. Use only when no longer using this object.
	static release = function()
	{
		buffer_delete(buffer_);	
	};
}

/// @hint new GMFMS_Buffer(size: int, alignment: int)->GMFMS_Buffer 
/// @hint GMFMS_Buffer:release()->void Frees the buffer from memory. Call this when deleting this object.
/// @hint GMFMS_Buffer:allocate(new_size: int)->void Allocates a new larger memory size.
/// @hint GMFMS_Buffer:read(type: buffer_type)->any Reads data from the buffer. Moves the read/write position.
/// @hint GMFMS_Buffer:readCharStar()->string Interprets a const C-string sent from an extension.
/// @hint GMFMS_Buffer:write(type: buffer_type, value: any)->void Write data into the buffer. Moves the read/write position.
/// @hint GMFMS_Buffer:seek(base: buffer_seek_base, rel_bytes: int)->void Seek to a position within the buffer.
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

/// @func GMFMS_Ptr(handle)
/// @returns {any}
function GMFMS_Ptr(handle)
{
	if (typeof(handle) == "struct") { // HTML5 behavior
		return handle;
	} else {                          // Windows
		return ptr(handle);
	}
}
