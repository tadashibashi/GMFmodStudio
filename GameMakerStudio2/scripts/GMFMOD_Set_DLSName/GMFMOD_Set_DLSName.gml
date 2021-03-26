/// @param   {string} path
/// @returns {void}
/// 
/// @description Sets the default DLS that will be set when triggering programmer sounds
function GMFMOD_Set_DLSName(path)
{
	fmod_studio_set_dlsname(working_directory + path);
}