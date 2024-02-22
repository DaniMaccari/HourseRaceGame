extends Node

onready var room = get_parent().get_parent().get_node("rooms")
var client_info = {
	"client_id": null,
	"nick_name": null,
	"room_id": null
}

func terminate():
	var res = room.get_node_or_null(str(client_info["room_id"]))
	if res != null:
		res.ExitClient(self.name)
	
