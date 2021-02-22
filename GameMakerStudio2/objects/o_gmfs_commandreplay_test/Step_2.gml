/// @description Insert description here
// You can write your code in this editor
var _3d_attr = new GMFMS_3DAttr();
inst.get3DAttributes(_3d_attr);
_3d_attr.position.x = 20 * (x - (room_width/2)) / room_width;
_3d_attr.position.z = 10;
inst.set3DAttributes(_3d_attr);

target_xscale = max(target_xscale, 0);
target_yscale = max(target_yscale, 0);

image_xscale = lerp(image_xscale, target_xscale, .1);
image_yscale = lerp(image_xscale, target_yscale, .1);

image_alpha = lerp(image_alpha, .2, .1);

inst.setVolume(image_xscale);
inst.setPitch(.25/image_xscale*16);

inst.setCallback(FMOD_STUDIO_EVENT_CALLBACK_ALL);

studio.update();