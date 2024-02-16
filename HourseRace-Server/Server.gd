extends Node

var network = NetworkedMultiplayerENet.new()

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
