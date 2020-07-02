extends Area2D


var tem_player = false
var first_player

var vel = 50
var deltamob
remotesync var posi = Vector2.ZERO



func _ready():
	randomize()
	set_process(true)
	
	get_node("/root/prontera_world/spaw_point").connect("area_entered", self, "_on_spaw_point_area_entered")
	get_node("/root/prontera_world/spaw_point").connect("area_exited", self, "_on_spaw_point_area_exited")
	pass 
	
func _process(delta):
	
	deltamob = delta
	
	
	if tem_player:
		var player = get_node("/root/prontera_world").get_node(str(first_player))
		var dif
		
		if player != null:
			dif = player.position - global_position
		else:
			dif = Vector2()
		
		var x_round = ceil(dif.x)
		var y_round = ceil(dif.y)
		
		if x_round < 0:
			x_round += 1
			translate(Vector2(-1,0) * vel * delta)
		
		if y_round < 0:
			y_round += 1
			translate(Vector2(0,-1) * vel * delta)
			
		if x_round > 0:
			x_round -= 1
			translate(Vector2(+1,0) * vel * delta)
		
		if y_round > 0:
			y_round -= 1
			translate(Vector2(0,+1) * vel * delta)
		
		
		
	else:
		if posi != Vector2.ZERO:
			var dif = posi - position
			var x_round = ceil(dif.x)
			var y_round = ceil(dif.y)
			
			if x_round < 0:
				x_round += 1
				translate(Vector2(-1,0) * vel * delta)
			
			if y_round < 0:
				y_round += 1
				translate(Vector2(0,-1) * vel * delta)
				
			if x_round > 0:
				x_round -= 1
				translate(Vector2(+1,0) * vel * delta)
			
			if y_round > 0:
				y_round -= 1
				translate(Vector2(0,+1) * vel * delta)
	
	
	#rpc_unreliable("setPosition", position)
	
	pass


func _on_spaw_point_area_entered(area):
	if area.is_in_group(global.GRUPO_PLAYER):
		tem_player = true
		first_player = area.name
		
	pass


func _on_spaw_point_area_exited(area):
	if area.is_in_group(global.GRUPO_PLAYER):
		tem_player = false
		first_player = null
		
	pass


func _on_Timer_timeout():
	posi = Vector2(rand_range(-100,100), rand_range(-100,100))
	for peer in multiplayer.get_network_connected_peers():
		if peer > 1:
			rset_unreliable_id(peer, "posi", posi)

	pass
