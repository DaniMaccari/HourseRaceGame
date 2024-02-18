extends Node

var network = NetworkedMultiplayerENet.new()

var ip_address = "127.0.0.1" #local IP
var port = 1909

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
