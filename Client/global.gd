extends Node

const GRUPO_MOBS = "mobs"
const GRUPO_PLAYER = "players"

var players = {}
var my_info = {}


func _ready():
	randomize()
	get_tree().multiplayer.connect("network_peer_connected", self, "_player_conected")
	get_tree().multiplayer.connect("network_peer_disconnected", self, "_player_disconnected")

	pass


func run_game(id,info):
	var world = load("res://prontera_world.tscn").instance()
	get_node("/root").add_child(world)
	
	my_info = info
	var player = preload("res://Player.tscn").instance()
	player.name = str(id)
	player.set_network_master(id)
	player.initialize(info)
	get_node("/root/prontera_world").add_child(player)
	players[id] = info
	
	
	var mob_red = preload("res://mobs/mob_red.tscn").instance()
	get_node("/root/prontera_world/spaw_point").add_child(mob_red)
	
	var mob_red2 = preload("res://mobs/mob_red.tscn").instance()
	get_node("/root/prontera_world/spaw_point").add_child(mob_red2)
	pass
	
func _player_conected(id):
	if id > 1:
		rpc_id(id, "register_player", my_info)
	pass
	
func _player_disconnected(id):
	if id > 1 and id != multiplayer.get_network_unique_id():
		players.erase(id)
		get_node_or_null("/root/prontera_world").get_node_or_null(str(id)).queue_free()
	pass


func send_server_mob(mob):
	rpc_id(1,"add_mob", multiplayer.get_network_unique_id(), mob)

remote func register_player(info):
	var id = get_tree().get_rpc_sender_id()
	
	players[id] = info
	
	var new_player = preload("res://Player.tscn").instance()
	new_player.set_name(str(id))
	new_player.set_network_master(id)
	new_player.initialize(players[id])
	get_node("/root/prontera_world").add_child(new_player)
	
	

remote func update_position(id,posi):
	players[id].posi = posi
