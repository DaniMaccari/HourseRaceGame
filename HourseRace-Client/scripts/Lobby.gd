extends Control

signal scene_change



func _on_TextureButton1_pressed():
	emit_signal("scene_change", "room_scene")


func _on_exit_pressed():
	emit_signal("scene_change", "menu_scene")
