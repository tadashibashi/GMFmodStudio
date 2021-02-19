function FmodBuffer(size, alignment) constructor
{
	// ===== "Private" ===========================================================
	buffer_ = buffer_create(size, buffer_fixed, alignment); /// @is {buffer}
	
	// ===== "Public" ============================================================
	static getSize = function()
	{
		var current_pos = buffer_tell(buffer_);
		buffer_seek(buffer_, buffer_seek_end, 0);
		var _size = buffer_tell(buffer_);
		buffer_seek(buffer_, buffer_seek_start, current_pos);
		
		return _size;
	};
	
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
	
	static getAlignment = function()
	{
		return buffer_get_alignment(buffer_);
	};
	
	static seekReset = function()
	{
		buffer_seek(buffer_, buffer_seek_start, 0);	
	};
	
	static tell = function()
	{
		return buffer_tell(buffer_);	
	};
	
	static read = function(data_type)
	{
		return buffer_read(buffer_, data_type);	
	};
	
	static readCharStar = function()
	{
		// read the pointer (should convert to 64bit uint on dll-side)
		var charPtr = buffer_read(buffer_, buffer_u64);
		return __gmfmod_interpret_string(charPtr);
	};
	
	static write = function(type, value)
	{
		buffer_write(buffer_, type, value);	
	};
	
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

/// @hint new FmodBuffer(size: int, alignment: int)->FmodBuffer 
/// @hint FmodBuffer:release()->void Frees the buffer from memory. Call this when deleting this object.
/// @hint FmodBuffer:allocate(new_size: int)->void Allocates a new larger memory size.
/// @hint FmodBuffer:read(type: buffer_type)->any Reads data from the buffer. Moves the read/write position.
/// @hint FmodBuffer:readCharStar()->string Interprets a const C-string sent from an extension.
/// @hint FmodBuffer:write(type: buffer_type, value: any)->void Write data into the buffer. Moves the read/write position.
/// @hint FmodBuffer:seek(base: buffer_seek_base, rel_bytes: int)->void Seek to a position within the buffer.
/// @hint FmodBuffer:seekReset()->void Seek back to the buffer's start position.
/// @hint FmodBuffer:tell()->int Tells the buffer's current read/write position.
/// @hint FmodBuffer:getSize()->int Gets the max size of the buffer in bytes.
/// @hint FmodBuffer:getAddress()->ptr Gets the address of this buffer.
/// @hint FmodBuffer:getAlignment()->int Gets the buffer's byte alignment.
/// @hint FmodBuffer:getBuffer()->buffer Gets the GameMaker Studio buffer.


/// @func FmodGetBuffer()
/// @desc Gets the global buffer to be used for passing data back and forth between
/// game maker and the GMFmodStudio Extension.
/// @returns {FmodBuffer} The global FmodBuffer object
function FmodGetBuffer()
{
	if (!variable_global_exists("__fmod_studio_extension_buffer"))
	{
		global.__fmod_studio_extension_buffer = new FmodBuffer(256, 1);
	}
	
	global.__fmod_studio_extension_buffer.seekReset();
	
	return global.__fmod_studio_extension_buffer;
}
