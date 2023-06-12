extends Node

const PORT = 3270
var peer = ENetMultiplayerPeer.new()

const Player = preload("res://car.tscn")


func hostGame() -> void:
	peer.create_server(PORT)
	Info.peer = peer
	
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start server")
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_connected.connect(add_lobby_card)
	multiplayer.peer_disconnected.connect(remove_player)
#	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	show_game()

func joinGame(IPtext : String) -> void:
	peer.create_client(IPtext, PORT)
	Info.peer = peer
	
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Could not connect, make sure you have typed the correct IP and the host has correctly forwarded port " + str(PORT))
		return
	multiplayer.multiplayer_peer = peer
	
	show_game()


func show_game():
	$menu.hide()
	$world.show()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


var lobbyCard = preload("res://PlayerMenuCard.tscn")
func add_lobby_card(peer_id):
	var cardParent = $menu/Lobby/
	pass


func add_player(peer_id):
	
	var player = Player.instantiate()
	player.name = str(peer_id)
#	var start_pos = await $world/map.get_unique_start_pos()
#	print(start_pos)
#	if start_pos == null:
#		OS.alert("Server is full.")
#		return false
#	player.get_node("VehicleBody3D").global_transform = start_pos
#	player.get_node("VehicleBody3D").global_position = Vector3(20, 5, 20)
	print(peer_id, Info.PlayerName)
	$world/Players.add_child(player)

func remove_player(peer_id):
	$world/Players.get_node(str(peer_id)).queue_free()
