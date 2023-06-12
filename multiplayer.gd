extends Node

const PORT = 3270
var peer = ENetMultiplayerPeer.new()

const Player = preload("res://car.tscn")

@rpc("any_peer", "reliable", "call_local")
func add_display_name(n) -> void:
	var id = multiplayer.get_remote_sender_id()
	Info.display_names[id] = n
	Info.display_names_changed.emit()

@rpc("reliable", "call_local")
func remove_display_name(peer_id):
	Info.display_names.erase(peer_id)
	Info.display_names_changed.emit()


func hostGame() -> void:
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start server")
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	add_display_name.rpc(Info.PlayerName)
	
	multiplayer.peer_connected.connect(send_previous_playernames)

func send_previous_playernames(new_peer_id):
	add_previous_display_names.rpc_id(new_peer_id, Info.display_names)

@rpc("reliable")
func add_previous_display_names(dict:Dictionary):
	Info.display_names.merge(dict)
	Info.display_names_changed.emit()

func joinGame(IPtext : String) -> void:
	peer.create_client(IPtext, PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Could not connect, make sure you have typed the correct IP and the host has correctly forwarded port " + str(PORT))
		return
	multiplayer.multiplayer_peer = peer
	
	multiplayer.connected_to_server.connect(connected)

func connected():
	add_display_name.rpc(Info.PlayerName)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		print(multiplayer.get_unique_id(), "  ", Info.display_names)



func add_player(peer_id):
	
	var player = Player.instantiate()
	player.name = str(peer_id)
#	var start_pos = await $world/map.get_unique_start_pos()
#	print(start_pos)
#	if start_pos == null:
#		OS.alert("Server is full.")
#		return false
#	player.get_node("VBody3D").global_transform = start_pos
#	player.get_node("VBody3D").global_position = Vector3(20, 5, 20)
#	print(peer_id, Info.PlayerName)
	
	$menu/world/Players.add_child(player)

func remove_player(peer_id):
	remove_display_name.rpc(peer_id)
	$menu/world/Players.get_node(str(peer_id)).queue_free()
