extends Node

var network = NetworkedMultiplayerENet.new()
var room = preload("res://scenes/room.tscn")
var client = preload("res://scenes/client.tscn")
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
	var new_client = client.instance()
	new_client.name = str(player_id)
	$clients.add_child(new_client)
	
func PlayerDisconnected(player_id):
	print(str(player_id) + " disconnected")
	#$clients.get_node(str(player_id)).terminate
	var disconnected_player = $clients.get_node_or_null(str(player_id))
	if disconnected_player != null:
		disconnected_player.terminate()

remote func JoinRoom_1():
	var client_id = get_tree().get_rpc_sender_id()
	
	#if already exist joins if not creates new one
	var r = $rooms.get_node_or_null("room_1")
	
	if r !=null: #join
		if (r.game_started == false) and (r.player_count < r.MAX_PLAYERS):
			if client_id in get_tree().get_network_connected_peers():
				rpc_id(client_id, "EnterRoom", "room_1")
				print("JoinRoom_1 - room joined")
		else:
			print("game full or started")
		
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
	
remote func AddClient(room_id):
	var client_id = get_tree().get_rpc_sender_id()
	var r = $rooms.get_node_or_null(room_id)
	if r != null:
		r.AddClient(client_id)
	else:
		print("room doesnt exist")

remote func UpdateClients(room_id):
	var client_id = get_tree().get_rpc_sender_id()
	var r = $rooms.get_node_or_null(room_id)
	if r != null:
		if client_id in get_tree().get_network_connected_peers():
			rpc_id(client_id, "UpdatedClients", r.client_list)

remote func ExitRoom(room_id):
	var client_id = get_tree().get_rpc_sender_id()
	var r = $rooms.get_node_or_null(room_id)
	if r != null:
		r.ExitClient(client_id)

remote func UpdateRooms():
	var client_id = get_tree().get_rpc_sender_id()
	rpc_id(client_id, "UpdatedRooms", $rooms.rooms_list)
	
#	for r in $rooms.get_children():
#
#		match value:
#			"room_1":
#		pass

remote func SendStartSignal(room_id):
	var client_id = get_tree().get_rpc_sender_id()
	var r = $rooms.get_node_or_null(room_id)
	if r != null:
		var keys = r.client_list.keys()
		if true:#client_id in keys:
			r.LoadStage()
			
			for client in keys:
				#print(client)
				rpc_id(int(client), "LoadStage", r.client_list)


remote func SendReadySignal(room_id):
	var client_id = get_tree().get_rpc_sender_id()
	var r = $rooms.get_node_or_null(room_id)
	if r != null:
		r.MakeReady(client_id)

func AllReady(client_keys):
	for c in client_keys:
		rpc_id(int(c), "all_ready")
	
remote func GetServerTime(client_time):
	var client_id = get_tree().get_rpc_sender_id()
	rpc_id(client_id, "ReturnServerTime", OS.get_system_time_msecs(), client_time)
	











