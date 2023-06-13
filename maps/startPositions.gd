extends Node3D

# ska fixa så platser blir lediga när någon lämnar.
var placement = {}

func get_start_position(peer_id):
	print(peer_id, "  ", placement)
	
	print(peer_id)
	# if player is already connected:
	if placement.has(peer_id):
		return [placement[peer_id].global_rotation, placement[peer_id].global_position]
	
	# if not, find them an available spot
	for area in get_children():
		if area in placement.values():
			# spot is occupied, next?
			continue
		# spot is available. return transform.
		placement[peer_id] = area
		return [area.global_rotation, area.global_position]
	
	# Server is full
	return null
