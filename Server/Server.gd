extends Node

const SERVER_PORT = 44405
const MAX_PLAYERS = 10



func _ready():
	var tempo = Timer.new()
	tempo.wait_time = 1
	add_child(tempo)
	tempo.start()
	
	
	var _ch = get_tree().connect("network_peer_connected", self, "_player_connected")
	var _ch2 = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	tempo.connect("timeout", self, "_timerout")
	start_server()
	

func _timerout():
	print(global.mobs)

func start_server():
	print("Tentando iniciar o servidor.")
	var peer = NetworkedMultiplayerENet.new()
	var result = peer.create_server(SERVER_PORT, MAX_PLAYERS)
	
	if result != OK:
		print("Falha ao criar o servidor.")
		return
	else:
		print("Servior criado!")
	
	get_tree().set_network_peer(peer)

func _player_connected(id):
	print(str(id) + " conectado ao servidor!")

func _player_disconnected(id):
	print(str(id) + " desconectado do servidor!")
	

