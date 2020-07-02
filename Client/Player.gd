extends Node2D

var players
var vel = 200
var myname
var menu
#var begingame = true
var edittextfocus = false

puppet func setPosition(pos):
	global_position = pos
	pass

func _ready():
	add_to_group(global.GRUPO_PLAYER)
	set_process(true)
	set_process_input(true)
	var tempo = Timer.new()
	add_child(tempo)
	tempo.wait_time = 1
	tempo.connect("timeout", self, "_timeout")
	tempo.start()
	
	
	get_node("/root/prontera_world/menu/Control/btn_close").connect("pressed", self, "_on_close_pressed")
	get_node("/root/prontera_world/menu/Control/btn_send_text").connect("pressed", self, "_on_send_text_pressed")
	get_node("/root/prontera_world/menu/Control/btn_logoff").connect("pressed", self, "_on_logoff_pressed")
	get_node("/root/prontera_world/menu/Control/edit_text_send").connect("text_entered", self, "_on_text_entered")
	get_node("/root/prontera_world/menu/Control/edit_text_send").connect("focus_entered", self, "_on_focus_enter")
	get_node("/root/prontera_world/menu/Control/edit_text_send").connect("focus_exited", self, "_on_focus_closed")
	

	pass

func _input(event):
	if event.is_action_pressed("ui_cancel") and edittextfocus:
		var btn = get_node("/root/prontera_world/menu/Control/btn_send_text") as Button
		btn.grab_focus()
	
	if event.is_action_pressed("ui_accept"):
		if menu == false:
			menu = true
		else:
			if !edittextfocus:
				menu = false
	pass

master func setVisible(visi):
	get_node("/root/prontera_world/menu/Control").visible = visi
	pass

func _process(delta):
	
	var moveByX = 0
	var moveByY = 0
	
	if is_network_master():
		if menu:
			rpc_id(multiplayer.get_network_unique_id(),"setVisible", true)
		else:
			rpc_id(multiplayer.get_network_unique_id(),"setVisible", false)
	
	if(is_network_master() and !edittextfocus):
		if Input.is_action_pressed("ui_up"):
			moveByY = -1
		if Input.is_action_pressed("ui_down"):
			moveByY = 1
		if Input.is_action_pressed("ui_left"):
			moveByX = -1
		if Input.is_action_pressed("ui_right"):
			moveByX = 1
		
		for peer in multiplayer.get_network_connected_peers():
			if peer > 1:
				rpc_unreliable_id(peer,"setPosition", global_position)
	
	translate(Vector2(moveByX,moveByY) * vel * delta)
	#global.players[multiplayer.get_network_unique_id()].posi = global_position
	#rpc("update_position",multiplayer.get_network_unique_id(), global_position)
	 
	
	

	pass
	
func _timeout():
	#print(global.players)
	
	pass

func initialize(mydata):
	$Sprite/lbl_name.text = mydata.nome
	global_position = mydata.posi
	myname = mydata.nome
	
	pass


func _on_send_text_pressed():
	var edit = get_node("/root/prontera_world/menu/Control/edit_text_send") as LineEdit
	var msg = edit.text
	
	if !edit.text.empty():
		rpc("_on_send", multiplayer.get_network_unique_id(), msg)
		edit.text = ""

remotesync func _on_send(id,msg):
	var nome = global.players[id].nome
	var richtext = get_node("/root/prontera_world/menu/Control/multiples_text") as RichTextLabel
	
	#richtext.text += "[fade start=4 length=14]"+nome+": "+msg+"[/fade]"
	richtext.bbcode_text += "[color=#88ffffff]"+nome+"[/color]: "+msg+" \n"
	
	pass

func _on_text_entered(new_text):
	var btnsend = get_node("/root/prontera_world/menu/Control/btn_send_text") as Button
	btnsend.emit_signal("pressed")
	btnsend.grab_focus()

func _on_close_pressed():
	multiplayer.set_network_peer(null)
	get_node("/root/prontera_world").queue_free()
	get_tree().quit()
	pass

func _on_logoff_pressed():
	multiplayer.set_network_peer(null)
	get_node("/root/prontera_world").queue_free()
	get_tree().change_scene("Cliente.tscn")
	pass

func _on_focus_enter():
	edittextfocus = true
	pass
	
func _on_focus_closed():
	edittextfocus = false
	pass
