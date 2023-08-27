extends Node3D

@onready var startPositions = get_parent().get_node("Map/startPositions")

var connected = false

func _ready() -> void:
	if multiplayer.is_server():
		connected = true
	else:
		multiplayer.connected_to_server.connect(
			func():
				connected = true
		)

func update_start_positions(_node:Node) -> void:
	if not connected:
		return
	
	for pos in startPositions.get_children():
		pos.remove_from_group("taken")
	
	
	var cars = []
	for player in get_children():
		cars.append(player.name.to_int())
	cars.sort()
	
	for player_name in cars:
		var player = get_node(str(player_name))
		for pos in startPositions.get_children():
			
			if pos.is_in_group("taken"):
				continue
			
			pos.add_to_group("taken")
			player.position = pos.global_position
			break
