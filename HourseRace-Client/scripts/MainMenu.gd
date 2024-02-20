extends Control

signal scene_change
onready var enterName = $LineEdit

func _ready():
	enterName.grab_focus()
	enterName.set_cursor_position(len(enterName.text))
	
func _on_play_pressed():
	emit_signal("scene_change", "lobby_scene")
