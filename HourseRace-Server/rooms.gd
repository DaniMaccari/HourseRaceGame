extends Node #see all rooms in lobby

var rooms_list = {}
var room_info = {
	"player_count": null,
	"game_started": false
}

func AddRoom(room_id):
	var r = room_info.duplicate()
	rooms_list[room_id] = r
	


func DeleteRoom(room_id):
	rooms_list.erase(room_id)

func UpdateRoom(room_id, r_info):
	rooms_list[room_id] = r_info
