extends Control

signal scene_change

func _on_play_pressed():
	emit_signal("scene_change", "lobby_scene")
