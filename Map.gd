extends Node3D

signal switched_map
var data : Dictionary

var current_save_name
var current_mapdata
#func _ready() -> void:
#	multiplayer.connected_to_server.connect(
#		func():
#			multiplayer.get_remote_sender_id()
#	)
#
#	multiplayer.peer_connected.connect(generate_map(current_save_name, current_mapdata))


@rpc("any_peer", "reliable", "call_local")
func generate_map(save_name, mapdata):
	if not DirAccess.dir_exists_absolute("user://maps/"+save_name):
		# download map to local computer
		var file = FileAccess.open("user://maps/"+save_name, FileAccess.WRITE)
		file.store_var(mapdata)
		file.close()
	
	current_save_name = save_name
	current_mapdata = mapdata
	
	switched_map.emit(save_name.replace(".save", ""))
	
	for gridmap_name in ["Ground", "Road", "Decoration"]:
		print(get_child_count())
		get_node(gridmap_name).clear()
		var gridmap = get_node(gridmap_name)
		
		for cell in mapdata[gridmap_name]:
			# convert Asset ID to item index and set cell
			var item_id:int = mapdata[gridmap_name][cell]["item"]
			var item_name:String = Assets.Tiles[gridmap_name][item_id]
			var item_index:int = gridmap.mesh_library.find_item_by_name(item_name)
			var cell_rotation:int = mapdata[gridmap_name][cell]["rotation"]
			gridmap.set_cell_item(cell, item_index, cell_rotation)

#func align_start_positions():
#	$startPositions.position = $Road.get_cell_item()

func load_map(save_file : String):
	var file = FileAccess.open("user://maps/"+save_file, FileAccess.READ)
	data = file.get_var()
	file.close()
	
	rpc("generate_map", save_file, data)
	
#	var editor = preload("res://Map editor/map_editor_main.tscn").instantiate()
#	editor.mapName = mapName
#	add_child(editor)
#	editor.load_map(data)
#	hide()
