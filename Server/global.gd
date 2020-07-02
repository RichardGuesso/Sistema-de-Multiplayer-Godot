extends Node

var mobs = {}

func _ready():
	randomize()
	pass

func send_server_mob(mob):
	rpc_id(1,"add_mob", multiplayer.get_network_unique_id(), mob)


remote func add_mob(id, info):
	mobs[id] = info
	pass
