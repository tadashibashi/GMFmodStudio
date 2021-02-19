/// @description Insert description here
// You can write your code in this editor
inst.stop();
inst.release();

studio.flushCommands();

show_debug_message("instance count: " + string(desc.getInstanceCount()));
