extends Control

signal scene_change

var client_list = {}

func _ready():
	Server.AddClient()
	$Label.text = "Room ID: " + str(Server.r_id)
	
func _on_exit_pressed():
	Server.ExitRoom()
	emit_signal("scene_change", "lobby_scene")

func UpdateClients(c_list):
	$ItemList.clear()
	
	client_list = c_list
	for c in client_list.keys():
		if c == str(get_tree().get_network_unique_id()):
			#$ItemList.add_item(client_list[c]["nick_name"], null, false)
			$ItemList.add_item(str(c) + " (YOU)", null, false)#nombre, textura, selectable
		else:
			#$ItemList.add_item(client_list[c]["nick_name"], null, false)
			$ItemList.add_item(str(c), null, false)#nombre, textura, selectable
	
func _on_TimerUpdatePlayers_timeout():
	Server.UpdateClients()

func _on_playButton_pressed():
	Server.SendStartSignal()
	#emit_signal("scene_change", "game_scene")
	pass # Replace with function body.

func LoadStage():
	emit_signal("scene_change", "game_scene")
