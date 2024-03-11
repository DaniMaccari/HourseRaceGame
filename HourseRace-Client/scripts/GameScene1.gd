extends Node2D

signal scene_change

var hourse_scene = preload("res://scenes/HoursePlayer_Duplicate.tscn")
var client_list

func _ready():
	client_list = Server.temp_list
	SpawnClients()
	print(client_list)

func SpawnClients():
	var pos_shift = 0
	
	#spawn clients
	for client in client_list.keys():
		
		var pos = Vector2(140, 80 + pos_shift)
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
