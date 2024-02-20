extends Node

onready var room = get_parent().get_parent().get_node("rooms")
var client_info = {
	"client_id": null,
	"nick_name": null,
	"room_id": null
}

func terminate():
	room.get_node_or_null(str(client_info["room_id"]))
	if room != null:
		room.ExitClient(self.name)
	
