var cshift = color_shift * 255;

// Draw background rect
draw_set_color(make_color_rgb(cshift, cshift, cshift));
draw_rectangle(x, y, x + window_width, y + window_height, false);

// Draw text
draw_set_color(make_color_rgb(255 - cshift, 255 - cshift, 255 - cshift));
draw_set_font(f_main);
if (currentTest < array_length(tests))
	draw_text(x + 10, y + 10, "Current Test: " + string(object_get_name(tests[currentTest])));
else
	draw_text(x + 10, y + 10, "Finished all tests!\n" + string(global.__GMFMS_success_count) + 
		" out of " + string(global.__GMFMS_test_count) + " tests passed.\nPress Escape to Exit.");

// Draw progress bar
draw_rectangle(x, y + window_height - 16, x + window_width * currentProgress / array_length(tests), y + window_height, false);