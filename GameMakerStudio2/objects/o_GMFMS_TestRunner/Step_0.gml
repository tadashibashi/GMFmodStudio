currentProgress = lerp(currentProgress, currentTest, .25);

if (currentTest >= array_length(tests) && color_shift < 1)
{
	color_shift = lerp(color_shift, 1, .025);
}