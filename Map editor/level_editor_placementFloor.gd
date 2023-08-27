extends StaticBody3D

var height :float = 0:
	set(val):
		get_node("../CanvasLayer/CurrentFloor").text = "Floor height " + str(val)
		height = val
	get:
		return height

func _input(event):
	if event.is_action_pressed("map_editor_floor_up"):
		height += $"..".working_gridmap.cell_size.y
		position.y = height
	if event.is_action_pressed("map_editor_floor_down"):
		height -= $"..".working_gridmap.cell_size.y
		position.y = height
