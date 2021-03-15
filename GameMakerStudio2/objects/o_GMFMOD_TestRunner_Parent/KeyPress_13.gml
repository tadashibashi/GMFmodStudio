// @description When tests are finished progresses to the next room

if (finished)
{
	if (room_next(room) != -1)
    {
		room_goto(room_next(room));
    }
}
