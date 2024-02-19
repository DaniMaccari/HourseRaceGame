extends Control

signal scene_change

func _on_exit_pressed():
	emit_signal("scene_change", "lobby_scene")
