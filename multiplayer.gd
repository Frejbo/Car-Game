extends Node

const PORT = 3270
var peer = ENetMultiplayerPeer.new()

const Player = preload("res://car.tscn")


func _on_host_pressed() -> void:
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start server")
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	show_game()

func _on_join_pressed() -> void:
	var txt = $CanvasLayer/VBoxContainer/HBoxContainer/IP.text
	
	peer.create_client(txt, PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Could not connect, make sure you have typed the correct IP and the host has correctly forwarded port " + str(PORT))
		return
	multiplayer.multiplayer_peer = peer
	
	show_game()


func show_game():
	$CanvasLayer.hide()
	$world.show()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED



func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	$world/Players.add_child(player)

func remove_player(peer_id):
	$world.get_node(str(peer_id)).queue_free()
