/// @description Insert description here
// You can write your code in this editor

arr = [0, 1, 2, 3, 4];

function hey(_arr)
{
	_arr[@3] = 10;
	return _arr;
}

bar = hey(arr);
bar[@4] = 10000000;
arr[2] = 1234;

show_debug_message(arr);
show_debug_message(bar);