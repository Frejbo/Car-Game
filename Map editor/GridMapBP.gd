extends GridMap


func _ready() -> void:
	get_node("../CanvasLayer/BuildSelector").switched_build_mode.connect(
		func(gridmap):
			mesh_library = gridmap.mesh_library
	)
