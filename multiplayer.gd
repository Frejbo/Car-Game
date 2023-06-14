extends Node

const PORT = 3270
var peer = ENetMultiplayerPeer.new()

const Player = preload("res://Bilar/Sedan/sedan.tscn")

@rpc("any_peer", "reliable", "call_local")
func add_display_name(namn) -> void:
	var id = multiplayer.get_remote_sender_id()
	Info.global_info["players"][id] = {"display_name": namn}
	Info.global_info_changed.emit()

@rpc("reliable", "call_local")
func remove_display_name(peer_id):
	Info.global_info["players"].erase(peer_id)
	Info.global_info_changed.emit()


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
	
	multiplayer.peer_connected.connect(send_previous_global_info)

func send_previous_global_info(new_peer_id):
	add_previous_global_info.rpc_id(new_peer_id, Info.global_info)

@rpc("reliable")
func add_previous_global_info(global_info:Dictionary):
	Info.global_info["players"].merge(global_info["players"])
	Info.global_info["seed"] = global_info["seed"]
	Info.global_info_changed.emit()

func joinGame(IPtext : String) -> void:
	peer.create_client(IPtext, PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Could not connect, make sure you have typed the correct IP and the host has correctly forwarded port " + str(PORT))
		return
	multiplayer.multiplayer_peer = peer
	
	multiplayer.connected_to_server.connect(connected)

func connected():
	add_display_name.rpc(Info.PlayerName)
#	place_car(peer_id)


func add_player(peer_id):
	var player = Player.instantiate()
	
	player.name = str(peer_id)
	
	$menu/world/Players.add_child(player)

func remove_player(peer_id):
	remove_display_name.rpc(peer_id)
	$menu/world/Players.get_node(str(peer_id)).queue_free()
