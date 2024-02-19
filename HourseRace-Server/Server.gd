extends Node

var network = NetworkedMultiplayerENet.new()
var room = preload("res://scenes/room.tscn")
var rng = RandomNumberGenerator.new()

var max_players = 64
var port = 1909

func _ready():
	StartServer()
	
func StartServer():
	network.create_server(port, max_players)
	get_tree().network_peer = network
	print("server started")
	
	get_tree().connect("network_peer_connected", self, "PlayerConnected")
	get_tree().connect("network_peer_disconnected", self, "PlayerDisconnected")

func PlayerConnected(player_id):
	print(str(player_id) + " is connected")

func PlayerDisconnected(player_id):
	print(str(player_id) + " disconnected")

remote func JoinRoom_1():
	var client_id = get_tree().get_rpc_sender_id()
	
	#if already exist joins if not creates new one
	var r = $rooms.get_node_or_null("room_1")
	
	if r !=null: #join
		#make join code
		print("JoinRoom_1 - room joined")
		pass
		
	else: #create new room
		var new_room = room.instance()
		var room_id = "room_1"
		new_room.name = str(room_id)
		$rooms.add_child(new_room)
		print("JoinRoom_1 - room created")
		
		if client_id in get_tree().get_network_connected_peers():
			rpc_id(client_id, "EnterRoom", room_id)
		else:
			$rooms.get_node(room_id).queue_free()
	
	pass
