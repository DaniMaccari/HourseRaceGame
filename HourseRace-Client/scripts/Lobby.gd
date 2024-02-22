extends Control

signal scene_change
onready var numPlayers1 = $TextureButton1/Label1Big


func _on_TextureButton1_pressed():
	#change later
	Server.JoinRoom_1()
	#Server.CreateRoom()
	#emit_signal("scene_change", "room_scene")

func _on_exit_pressed():
	emit_signal("scene_change", "menu_scene")
	
func EnterRoom():
	emit_signal("scene_change", "room_scene")


func _on_TimerPlayerCount_timeout():
	Server.UpdateRooms()

func UpdatedRooms(rooms_list):
	numPlayers1.text = "0"
	for room in rooms_list.keys():
		
		if rooms_list[room]["game_started"] == true:
			return #luego hacer que si la partida está empezada cambiar boton
			
		match room:
			"room_1":
				numPlayers1.text = str(rooms_list[room]["player_count"])
			"room_2":
				numPlayers1.text = str(rooms_list[room]["player_count"])
			"room_3":
				numPlayers1.text = str(rooms_list[room]["player_count"])
			_:
				pass





