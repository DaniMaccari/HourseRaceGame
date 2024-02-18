extends Node

var loader
var time_max = 100
var wait_frame = 0
var current_scene

func _ready():
	current_scene = load("res://scenes/MainMenu.tscn").instance()
	add_child(current_scene)
	current_scene.connect("scene_change", self, "handle_scene_change")

func handle_scene_change(scene_name):
	
	match scene_name:
		"room_scene": #waiting match to start
			loader = ResourceLoader.load_interactive("res://scenes/RoomScene.tscn")
		"lobby_scene": #find a room to play
			loader = ResourceLoader.load_interactive("res://scenes/Lobby.tscn")
		"menu_scene": #start scene, menu
			loader = ResourceLoader.load_interactive("res://scenes/MainMenu.tscn")
		"game_scene": #ingame match started
			loader = ResourceLoader.load_interactive("res://scenes/GameScene.tscn")
#		_:
#			loader = null
	
	if loader == null:
		print("scene doesnt exist")
		return
	
	$progressBar.value = 0
	$progressBar.visible = true
	set_process(true)
	wait_frame = 1
	current_scene.queue_free()
	
func _process(delta):
	if loader == null:
		set_process(false)
		return
	if wait_frame > 0:
		wait_frame -= 1
		return
	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t+ time_max:
		var err = loader.poll()
		
		if err == ERR_FILE_EOF:
			var next_scene = loader.get_resource()
			loader = null
			set_new_scene(next_scene)
			break
			
		elif err == OK:
			update_progress()
			
		else:
			print(err)
			loader = null
			break

func set_new_scene(next_scene):
	$progressBar.visible = false
	current_scene = next_scene.instance()
	current_scene.connect("scene_change", self, "handle_scene_change")
	add_child(current_scene)

func update_progress():
	var progress = (float(loader.get_stage()) / loader.get_stage_count()) * 100
	$progressBar.value = progress
	








