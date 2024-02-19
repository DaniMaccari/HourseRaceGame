extends Control

signal scene_change



func _on_TextureButton1_pressed():
	#change later
	Server.JoinRoom_1()
	#Server.CreateRoom()
	#emit_signal("scene_change", "room_scene")

func _on_exit_pressed():
	emit_signal("scene_change", "menu_scene")
	
func EnterRoom():
	emit_signal("scene_change", "room_scene")
