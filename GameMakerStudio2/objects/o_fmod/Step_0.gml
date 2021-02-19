/// @description Insert description here
// You can write your code in this editor

var xaxis = (keyboard_check(vk_right) - keyboard_check(vk_left))
var yaxis = (keyboard_check(vk_down) - keyboard_check(vk_up));

x += xaxis;
y += yaxis;

fmod_studio_system_update(studio);