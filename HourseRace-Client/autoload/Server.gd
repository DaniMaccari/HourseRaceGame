extends Node

var network = NetworkedMultiplayerENet.new()
#target everyone id = 0
#target server id = 1

var ip_address = "127.0.0.1" #local IP
var port = 1909
onready var scene_handler = get_node("/root/scene_handler")

var temp_list

var r_id = "room_default"

var client_clock = OS.get_system_time_msecs()
var latency = 0
var decimal_collector = 0.0

func _ready():
	StartClient()

func _physics_process(delta):
	client_clock += int(delta * 1000)
	decimal_collector += (delta * 1000) - int(delta * 1000)
	if decimal_collector >= 1.00:
		client_clock += 1
		decimal_collector -= 1
	
	
func StartClient():
	network.create_client(ip_address, port)
	get_tree().network_peer = network
	
	get_tree().connect("connected_to_server", self, "ConnectionSuccess")
	get_tree().connect("connection_failed", self, "ConnectionFailed")

func ConnectionSuccess():
	print("connecion success")
	rpc_id(1, "GetServerTime", OS.get_system_time_msecs())
	#start timer for resync
	var timer_resync = Timer.new()
	timer_resync.wait_time = 6
	timer_resync.autostart = true
	timer_resync.connect("timeout", self, "Resync")
	get_parent().get_node("scene_handler").add_child(timer_resync)
	
func ConnectionFailed():
	print("connection failed")

remote func ReturnServerTime(server_time, old_time_client):
	latency  = (OS.get_system_time_msecs() - old_time_client) / 2
	client_clock = server_time + latency
	
func Resync():
	rpc_id(1, "GetServerTime", OS.get_system_time_msecs())
	
func CreateRoom():
	rpc_id(1, "create_room")
	pass

func JoinRoom_1():
	rpc_id(1, "JoinRoom_1")
	pass

remote func EnterRoom(room_id):
	if get_tree().get_rpc_sender_id() != 1:
		return
	
	r_id = room_id
	var res = scene_handler.get_node_or_null("Lobby")
	if res != null:
		res.EnterRoom()
	else:
		print("EnterRoom - scene doesnt exist")

func AddClient():
	rpc_id(1, "AddClient", r_id)

func UpdateClients():
	rpc_id(1, "UpdateClients", r_id)

remote func UpdatedClients(c_list):
	if get_tree().get_rpc_sender_id() != 1:
		return
	var res = scene_handler.get_node_or_null("RoomScene")
	if res != null:
		res.UpdateClients(c_list)

func ExitRoom():
	rpc_id(1, "ExitRoom", r_id)

func UpdateRooms():
	rpc_id(1, "UpdateRooms")

remote func UpdatedRooms(rooms_list):
	if get_tree().get_rpc_sender_id() != 1:
		return
	var res = scene_handler.get_node_or_null("Lobby")
	if res != null:
		res.UpdatedRooms(rooms_list)

func SendStartSignal():
	rpc_id(1, "SendStartSignal", r_id)

func SendReadySignal():
	rpc_id(1, "SendReadySignal", r_id)

remote func LoadStage(client_list):
	if get_tree().get_rpc_sender_id() != 1:
		return
	
	var res = scene_handler.get_node_or_null("RoomScene")
	if res != null:
		temp_list = client_list
		res.LoadStage()
	
remote func AllReady():
	if get_tree().get_rpc_sender_id() != 1:
		return
	
	var res = scene_handler.get_node_or_null("GameScene1")
	if res != null:
		res.StartMatch()

func SendClientInput(c_input):
	if network.get_connection_status() == 2:
		rpc_unreliable_id(1, "ClientInputUpdate", c_input, r_id)














