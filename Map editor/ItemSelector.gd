extends ItemList

var selected_item := 0
var meshlib : MeshLibrary

func _ready() -> void:
	$"../BuildSelector".switched_build_mode.connect(
		func(_gridmap):
			update_items()
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("map_editor_inventory"):
		open_close()

func open_close() -> void:
	match visible:
		true:
			hide()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		false:
			show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func update_items() -> void:
	if meshlib == $"../..".working_gridmap.mesh_library: return
	meshlib = $"../..".working_gridmap.mesh_library
	
	clear()
	selected_item = 0
	for i in meshlib.get_item_list():
		add_item(meshlib.get_item_name(i), meshlib.get_item_preview(i), false)

func _on_item_selected(index: int) -> void:
	selected_item = index
	open_close()
