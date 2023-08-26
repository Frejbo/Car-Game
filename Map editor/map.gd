extends Node3D

var mapName := "Unknown map"
@onready var working_gridmap : GridMap

func _enter_tree() -> void:
	for x in range(-20, 20):
		for z in range(-20, 20):
			$Ground.set_cell_item(Vector3(x, 0, z), 0)


func _notification(what: int) -> void:
	if what == NOTIFICATION_EXIT_TREE:
		save_map()

func save_map() -> void:
	var data := {"Ground":{}, "Road":{}, "Decoration":{}}
	
	for gridmap_name in ["Ground", "Road", "Decoration"]:
		var gridmap = get_node(gridmap_name)
		for cell in gridmap.get_used_cells():
			# convert cell item index to Asset ID and save
			var cell_item:int = gridmap.get_cell_item(cell)
			var item_name:String = gridmap.mesh_library.get_item_name(cell_item)
			var item_id:int = Assets.Tiles[gridmap_name].find_key(item_name)
			data[gridmap_name][cell] = {"rotation":gridmap.get_cell_item_orientation(cell), "item": item_id}
	
	var file = FileAccess.open("user://maps/"+mapName+".save", FileAccess.WRITE)
	file.store_var(data)
	file.close()

func load_map(data) -> void:
	$Ground.clear()
	
	for gridmap_name in ["Ground", "Road", "Decoration"]:
		var gridmap = get_node(gridmap_name)
		for cell in data[gridmap_name]:
			# convert Asset ID to item index and set cell
			var item_id:int = data[gridmap_name][cell]["item"]
			var item_name:String = Assets.Tiles[gridmap_name][item_id]
			var item_index:int = gridmap.mesh_library.find_item_by_name(item_name)
			var cell_rotation:int = data[gridmap_name][cell]["rotation"]
			gridmap.set_cell_item(cell, item_index, cell_rotation)


func _on_autosave_timeout() -> void:
	save_map()
