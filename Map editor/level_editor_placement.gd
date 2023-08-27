extends RayCast3D

#@onready var gridmap = get_node("../../../Road")
@onready var gridmapBP = get_node("../../../GridMapBP")
@onready var itemSelector = get_node("../../../CanvasLayer/ItemSelector")
@onready var grandparent = get_node("../../..")

var allowed_rotation := [0, 16, 10, 22]

func _input(event):
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: return
	
	if event.is_action_pressed("map_editor_rotate_R"):
		allowed_rotation.insert(0, allowed_rotation[3])
		allowed_rotation.remove_at(4)
	if event.is_action_pressed("map_editor_rotate_L"):
		allowed_rotation.insert(4, allowed_rotation[0])
		allowed_rotation.remove_at(0)
	
	GetPointedCell()
	gridmapBP.clear()
	if is_colliding():
		gridmapBP.set_cell_item(GetPointedCell(), itemSelector.selected_item, allowed_rotation[0])
	
#	grandparent.working_gridmap.find_item_by_name()
	
	if event.is_action_pressed("map_editor_place"):
		grandparent.working_gridmap.set_cell_item(GetPointedCell(), itemSelector.selected_item, allowed_rotation[0])
	if event.is_action_pressed("map_editor_remove"):
		grandparent.working_gridmap.set_cell_item(GetPointedCell(), -1, 0)
	
#	if is_colliding():
#		get_node("../../../placementFloor").position.x = get_collision_point().snapped(Vector3.ONE).x
#		get_node("../../../placementFloor").position.z = get_collision_point().snapped(Vector3.ONE).z
#	else:
	get_node("../../../placementFloor").position.x = get_node("../..").position.snapped(Vector3.ONE).x
	get_node("../../../placementFloor").position.z = get_node("../..").position.snapped(Vector3.ONE).z

func GetPointedCell() -> Vector3i:
	return grandparent.working_gridmap.local_to_map(get_collision_point().snapped(Vector3(.1, .1, .1))) #snapped to prevent weird glitches where the raycast would return the block below current floor

