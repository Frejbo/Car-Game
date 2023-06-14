extends Node

const PORT = 3270
var peer = ENetMultiplayerPeer.new()

const Player = preload("res://car.tscn")

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
	add_previous_global_info.rpc_id(new_peer_id, Info.global_info, get_node("menu/world/map/startPositions").placement)

@rpc("reliable")
func add_previous_global_info(global_info:Dictionary, start_placement:Dictionary):
	Info.global_info["players"].merge(global_info["players"])
	Info.global_info["seed"] = global_info["seed"]
	Info.global_info_changed.emit()
#	place_car(multiplayer.get_unique_id())
	
	get_node("menu/world/map/startPositions").placement.merge(start_placement)

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
#	var start_pos = await $world/map.get_unique_start_pos()
#	print(start_pos)
#	if start_pos == null:
#		OS.alert("Server is full.")
#		return false
#	player.get_node("VBody3D").global_transform = start_pos
#	player.get_node("VBody3D").global_position = Vector3(20, 5, 20)
#	print(peer_id, Info.PlayerName)
	
	$menu/world/Players.add_child(player)
	
#	place_car(peer_id)

#func place_car(peer_id):
#	# doesnt work on client side?
#
#	var startPositions = get_node("menu/world/map/startPositions")
#	var new_transform = await startPositions.get_start_position(peer_id)
#	var player = get_node("menu/world/Players/").get_node(str(peer_id))
#
#	print(new_transform)
#	if new_transform == null:
#		OS.alert("Server is full or already running.")
#		get_tree().quit()
#	await get_tree().create_timer(1).timeout
#	player.global_rotation = new_transform[0]
#	player.position = new_transform[1]

func remove_player(peer_id):
	remove_display_name.rpc(peer_id)
	$menu/world/Players.get_node(str(peer_id)).queue_free()
