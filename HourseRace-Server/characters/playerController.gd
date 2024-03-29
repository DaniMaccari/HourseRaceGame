extends KinematicBody2D


const SPEED = 45
var buttonPoints = 0
var actualPoints = 0

var timer = 0
var minTimeBetweenTicks = 1/60.0
var currentTick = 0


#var stateBuffer = []
var default_state = {"T" :0, "B" :0}

var inputQueue = []
const BUFFER_SIZE = 1024
var inputBuffer = []
var stateBuffer = {}

var ServerTick = 0

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
	
	#var bufferIndex = -1
	var statepayload
	while inputQueue.size() > 0:
		var last_input = inputQueue.pop_front()
		ServerTick = last_input["T"]
		statepayload = ProcessInput(last_input)
	
	#if bufferIndex != -1:
	get_parent().get_parent().SendPlayerState(self.name, statepayload)

	
	#ProcessInput(clientInput)
	#buttonPoints = 0

func ProcessInput(input):
	
	actualPoints += input["B"]
#	#velocity.x = move_toward(1, 0, SPEED)
	if actualPoints > 100:
		move_and_slide(Vector2(SPEED *1.5, 0))
		actualPoints -= 2
	elif actualPoints > 0:
		move_and_slide(Vector2(SPEED, 0))
		actualPoints -= 1
		
	return{ "T": input["T"], "P": transform.origin}

	
func scorePoints(numPoints):
	buttonPoints = numPoints
	

func OnClientInput(input):
	inputQueue.append(input)









