extends Node3D

@onready var startPositions = get_parent().get_node("map/startPositions")

var connected = false

func _ready() -> void:
	if multiplayer.is_server():
		connected = true
	else:
		multiplayer.connected_to_server.connect(
			func():
				connected = true
		)

func update_start_positions(node: Node) -> void:
#	await get_tree().create_timer(1).timeout
	if not connected:
		return
	
	for pos in startPositions.get_children():
		pos.remove_from_group("taken")
	
	
#	if multiplayer.is_server():
#		for pos in startPositions.get_children():
#			pos.remove_from_group("taken")
#			pos.name = "available"
	var cars = []
	for player in get_children():
		cars.append(player.name.to_int())
	cars.sort()
#		func sort_ascending(a, b):
#			if a < b:
#				return true
#			return false
#	)
	
	print(multiplayer.get_unique_id(), "   ", cars)
	
	for player_name in cars:
		var player = get_node(str(player_name))
		for pos in startPositions.get_children():
			
			if pos.is_in_group("taken"):
				continue
			
			pos.add_to_group("taken")
			player.global_position = pos.global_position
			break
