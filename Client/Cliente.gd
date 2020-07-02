extends Node

const SERVER_IP = "defencebr.servegame.com"
const SERVER_PORT = 44405

var _connected = false

func _ready():
	
	var _ch = get_tree().connect("connected_to_server", self, "_connected_to_server")
	var _cn = get_tree().connect("connection_failed", self, "_connection_filed")

func _connection_filed():
	$Timer.stop()
	$GUI/edit_name.editable = true
	$GUI/edit_position_x.editable = true
	$GUI/edit_position_y.editable = true
	$GUI/btn_start.text = "Conectar"
	$GUI/btn_start.disabled = false
	print("Servidor Offline")

func _on_Timer_timeout():
	if !_connected:
		connect_to_server()

func connect_to_server():
	print("Tentando entrar no servidor.")
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().set_network_peer(peer)

func _connected_to_server():
	var my_info = {nome = $GUI/edit_name.text, posi = Vector2($GUI/edit_position_x.text,$GUI/edit_position_y.text)}
	print("Entrando para Lobby.")
	$Timer.stop()
	print("Conectado!")
	get_tree().change_scene("res://World.tscn")
	global.run_game(multiplayer.get_network_unique_id(), my_info)


func _on_btn_start_pressed():
	if valida_campo():
		connect_to_server()
		$Timer.start()
		$GUI/edit_name.editable = false
		$GUI/edit_position_x.editable = false
		$GUI/edit_position_y.editable = false
		$GUI/btn_start.text = "Conectando-se..."
		$GUI/btn_start.disabled = true


func valida_campo() -> bool:
	var nome = $GUI/edit_name
	var x = $GUI/edit_position_x
	var y = $GUI/edit_position_y
	
	if !nome.text.empty() and !x.text.empty() and !y.text.empty():
		return true
	else:
		if nome.text.empty():
			nome.grab_focus()
		elif x.text.empty():
			x.grab_focus()
		elif y.text.empty():
			y.grab_focus()
		return false



func _on_btn_exit_pressed():
	get_tree().network_peer = null
	get_tree().quit()
	pass



func _on_edit_position_x_focus_exited():
	if !$GUI/edit_position_x.text.is_valid_integer():
		$GUI/edit_position_x.text = ""
		$GUI/edit_position_x.grab_focus()
	else:
		var x = $GUI/edit_position_x.text as int
		if x > 700:
			$GUI/edit_position_x.text = "1000"


func _on_edit_position_y_focus_exited():
	
	if !$GUI/edit_position_y.text.is_valid_integer():
		$GUI/edit_position_y.text = ""
		$GUI/edit_position_y.grab_focus()
	else:
		var y = $GUI/edit_position_y.text as int
		if y > 700:
			$GUI/edit_position_y.text = "700"


