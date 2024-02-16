extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const SPEED = 30
var actualButtonPoints = 0
var buttonPoints = 0


var timer = 0
var minTimeBetweenTicks = 1/60.0
var currentTick = 0
const BUFFER_SIZE = 1024
var inputBuffer = []
#var stateBuffer = []
var default_state = {"T" :0, "B" :0}

# Called when the node enters the scene tree for the first time.
func _ready():
	inputBuffer.resize(BUFFER_SIZE)
	#stateBuffer.resize(BUFFER_SIZE)

func _process(delta):
	
	timer += delta
	
	while timer >= minTimeBetweenTicks:
		timer -= minTimeBetweenTicks
		HandleTick()
		currentTick += 1
	pass

func HandleTick():
	
	var clientInput = {}
	clientInput["T"] = currentTick
	clientInput["B"] = buttonPoints
	
	ProcessInput(clientInput)
	
	pass

func ProcessInput(input):
	
	#velocity.x = move_toward(1, 0, SPEED)
	if ( buttonPoints > 0):
		move_and_slide(Vector2(SPEED, 0))
		buttonPoints -= 1
	pass

#func _unhandled_key_input(event):
#	if Input.is_action_just_pressed("mainButton"):
#		buttonPoints += 10
	
func scorePoints(numPoints):
	buttonPoints += numPoints
