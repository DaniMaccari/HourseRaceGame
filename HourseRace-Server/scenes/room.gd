extends Viewport

var client_list = {}
var client_info = {
	"client_id": null,
	"nick_name": null,
	"room_id": null
}

const MAX_PLAYERS = 8
var player_count = 0
var game_started = false

func _ready():
	get_parent().add_room(self.name)
	
func AddClient(c_id):
	if client_list.size() > MAX_PLAYERS:
		print("room.AddClient - room full")
		return
	
	var new_client = client_info.duplicate()
	var c = get_parent().get_parent().get_node("clients").get_node(str(c_id))
	new_client["client_id"] = c_id
	new_client["nick_name"] = c.client_info["nick_name"]
	new_client["room_id"] = self.name
	c.client_info = new_client
	client_list[str(c_id)] = new_client
	UpdateCount()

func ExitClient(c_id):
	client_list.erase(str(c_id))
	UpdateCount()
	if player_count == 0:
		get_parent().DeleteRoom(self.name)
		self.queue_free() #change later

func UpdateCount():
	player_count = 0
	for c in client_list.keys():
		player_count += 1
	get_parent().update_room(self.name, {"player_count": player_count, "game_started": game_started})






