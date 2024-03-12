extends Viewport

var stage_scene = preload("res://stages/stage1/GameScene1_Server.tscn")
var hourse_scene = preload("res://characters/HoursePlayer_Server.tscn")

var client_list = {}
var client_info = {
	"client_id": null, #int
	"nick_name": null, #string
	"room_id": null, #string
	"ready": false #bool
}

const MAX_PLAYERS = 8
var player_count = 0
var game_started = false

var currentTick = 0
const SERVER_TICK_RATE = 20
var minTimeBetweenTicks = 1 / SERVER_TICK_RATE
var world_state = {}
var worldstate_buffer = {}
var timer = 0

func _ready():
	get_parent().AddRoom(self.name)
	set_process(false)

func SendPlayerState(id, state):
	worldstate_buffer[id] = state

func _process(delta):
	timer += delta
	
	while timer >= minTimeBetweenTicks:
		timer -= minTimeBetweenTicks
		HandleTick()

func HandleTick():
	
	if client_list.size() > 0:
		world_state["T"] = OS.get_system_time_msecs()
		
		for c in $clients.get_children():
			if worldstate_buffer[c.name] != null:
				world_state[c.name] = worldstate_buffer[c.name]
		
		for c in $clients.get_children():
			get_parent().get_parent().SendWorldState(world_state, int(c.name), self.name)



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
	get_parent().UpdateRoom(self.name, {"player_count": player_count, "game_started": game_started})

func LoadStage():
	#already exists dont duplicate
	if get_node_or_null("stage1") != null:
		return

	game_started = true
	get_parent().UpdateRoom(self.name, {"player_count": player_count, "game_started": game_started})
	var stage = stage_scene.instance()
	stage.name = "stage1"
	add_child(stage)
	
	var pos_shift = 80
	
	#spawn clients
	for client in client_list.keys():
		
		var pos = Vector2(140, pos_shift)
		var new_client = hourse_scene.instance()
		new_client.name = client
		new_client.transform.origin = pos
		$clients.add_child(new_client)
		
		print(pos)
		
		pos_shift += 20
	
	$timerCheckReady.start()

func MakeReady(client_id):
	client_list[str(client_id)]["ready"] = true
	

func _on_timerCheckReady_timeout():
	
	var still_waiting = false
	for c in client_list.keys():
		if client_list[str(c)]["ready"] == false:
			still_waiting = true
			break
		else:
			pass
	
	if !still_waiting:
		get_parent().get_parent().AllReady(client_list.keys())
		$timerCheckReady.queue_free()
		set_process(true)
















