extends Node

var network = NetworkedMultiplayerENet.new()
#target everyone id = 0
#target server id = 1

var ip_address = "127.0.0.1" #local IP
var port = 1909
onready var scene_handler = get_node("/root/scene_handler")

func _ready():
	StartClient()
	
func StartClient():
	network.create_client(ip_address, port)
	get_tree().network_peer = network
	
	get_tree().connect("connected_to_server", self, "ConnectionSuccess")
	get_tree().connect("connection_failed", self, "ConnectionFailed")

func ConnectionSuccess():
	print("connecion success")
	
func ConnectionFailed():
	print("connection failed")

func CreateRoom():
	rpc_id(1, "create_room")
	pass

func JoinRoom_1():
	rpc_id(1, "JoinRoom_1")
	pass

remote func EnterRoom(room_id):
	if get_tree().get_rpc_sender_id() != 1:
		return
	
	var res = scene_handler.get_node_or_null("Lobby")
	if res != null:
		res.EnterRoom()
	else:
		print("EnterRoom - scene doesnt exist")
