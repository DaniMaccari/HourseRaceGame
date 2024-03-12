extends Node2D

signal scene_change

var hourse_scene = preload("res://scenes/HoursePlayer_Duplicate.tscn")
var client_list

func _ready():
	client_list = Server.temp_list
	SpawnClients()
	print("GameScene, _ready")
	print(client_list)

func SpawnClients():
	var pos_shift = 80
	
	#spawn clients
	for client in client_list.keys():
		
		var pos = Vector2(140, pos_shift)
		pos_shift += 20
		
		#if its me
		if client == str(get_tree().get_network_unique_id()):
			print("my position")
			$HoursePlayer.transform.origin = pos
		
		#other player
		else:
			print("other player position")
			var new_client = hourse_scene.instance()
			new_client.name = client
			new_client.transform.origin = pos
			add_child(new_client)
	
	Server.SendReadySignal()

func StartMatch():
	$Node2D.StartPointer()
	#do the rest of the stuff 3, 2, 1

func UpdateWorldState(world_state):
	for c in world_state.keys():
		print("GameScene1, UpdateWorldState" ) #+ str(c)
		if world_state[c]["player_id"] == get_tree().get_network_unique_id():
			continue
		else:
			get_node(c).transform.origin = world_state[c]["P"]














