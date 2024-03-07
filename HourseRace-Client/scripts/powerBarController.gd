extends Node2D


const MINSPEED = 200
const MAXSPEED = MINSPEED*8
var SPEED = MINSPEED
var direction = 1
var _canActivate

var timer
var _isOut

onready var pointer = get_node("Pointer")
onready var posNodeEnd = get_node("endPosition")
var posEnd

onready var posNode1 = get_node("bluePosition")
var pos1
onready var posNode2 = get_node("greenPosition")
var pos2
onready var posNode3 = get_node("yellowPosition")
var pos3
onready var posNode4 = get_node("orangePosition")
var pos4
onready var posNodeBad = get_node("redPosition")
var posBad

var points0 = 80
var points1 = 60
var points2 = 50
var points3 = 30
var points4 = 20


func _ready():
	posEnd = posNodeEnd.position.y
	posBad = posNodeBad.position.y
	
	pos1 = posNode1.position.y
	pos2 = posNode2.position.y
	pos3 = posNode3.position.y
	pos4 = posNode4.position.y
	_canActivate = true
	_isOut = false
	pass # Replace with function body.


func _physics_process(delta):
	
	if _isOut: #dont do nothing
		return
		
	
	#change direction
	if pointer.position.y > posEnd:
		pointer.position.y = posEnd
		direction = -1
		ChangeDirection()
	
	elif pointer.position.y < (-posEnd):
		pointer.position.y = -posEnd
		direction = +1
		ChangeDirection()
	
	#move pointer
	pointer.move_and_slide(Vector2( 0, direction*SPEED))
	
func _unhandled_key_input(event):
	
	if _isOut:
		return
	
	if Input.is_action_just_pressed("mainButton") && _canActivate:
		
		_canActivate = false
		
		var absPointerPos = abs(pointer.position.y)
		var numberOfPoints = 0
		#clics wrong
		if absPointerPos > posBad:
			RestartSpeed()
		elif absPointerPos < pos1: #big price
			print("BIG PRICE")
			numberOfPoints = points0
		elif absPointerPos < pos2:
			print("BLUE TIER")
			numberOfPoints = points1
		elif absPointerPos < pos3:
			print("GREEN SCREEN")
			numberOfPoints = points2
		elif absPointerPos < pos4:
			print("YELLOW MELLOW")
			numberOfPoints = points3
		else:
			print("ALMOST OUT ORANGE")
			numberOfPoints = points4
		get_parent().get_node("HoursePlayer").scorePoints(numberOfPoints)
		#$playerController.scorePoints(numberOfPoints)
		#res://scripts/playerController.gd

func ChangeDirection():
	
	#not pressed
	if _canActivate == true:
		RestartSpeed()
		
	if SPEED < MAXSPEED:
		SPEED += SPEED*0.1
	else:
		SPEED = MAXSPEED
	
	_canActivate = true

func RestartSpeed():
	_isOut = true
	
	timer = Timer.new()
	timer.wait_time = 2.0
	timer.connect("timeout", self, "ResumePointer")
	add_child(timer)
	
	timer.start()
	SPEED = MINSPEED
	
func ResumePointer():
	_isOut = false
	timer.queue_free()
	





