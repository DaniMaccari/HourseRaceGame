extends Viewport

var client_list = {}
var client_info = {
	"client_id": null,
	"nick_name": null,
	"room_id": null
}

const MAX_PLAYERS = 8

func AddClient(c_id):
	if client_list.size() > MAX_PLAYERS:
		print("room.AddClient - room full")
		return
	
	var new_client = client_info.duplicate()
	var c = get_parent().get_parent().get_node("clients").get_node(str(c_id))
	new_client["client_id"] = c.client_info["client_id"]
	new_client["nick_name"] = c.client_info["nick_name"]
	new_client["room_id"] = self.name
	c.client_info = new_client
	client_list[str(c_id)] = new_client
	pass
