
my_object = {
	use: function() {
		return 12345;
	}
};

function grab_object()
{
	return my_object;
}

function use_object(obj)
{
	console.log(obj);
	return obj.use();
}

function socialAsyncExample(myStr)
{
	var map = {};
	map["id"] = "mysocialasyncdata";
	map["val"] = myStr;
	map["name"] = "BobJoeIII!"; 

	GMS_API.send_async_event_social(map);
}
