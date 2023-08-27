extends HBoxContainer

@onready var grandparent = get_node("../..")
signal switched_build_mode

func _ready() -> void:
	# Default when opening editor:
	_on_road_pressed()

func _input(event: InputEvent) -> void:
	# enable shortcuts for different categories
	if event.is_action_pressed("map_editor_select_buildmode_ground"):
		_on_ground_pressed()
	if event.is_action_pressed("map_editor_select_buildmode_road"):
		_on_road_pressed()
	if event.is_action_pressed("map_editor_select_buildmode_decoration"):
		_on_decoration_pressed()

func _on_ground_pressed() -> void:
	select($Ground)
	var gridmap = grandparent.get_node("Ground")
	grandparent.working_gridmap = gridmap
	switched_build_mode.emit(gridmap)


func _on_road_pressed() -> void:
	select($Road)
	var gridmap = grandparent.get_node("Road")
	grandparent.working_gridmap = gridmap
	switched_build_mode.emit(gridmap)


func _on_decoration_pressed() -> void:
	select($Decoration)
	var gridmap = grandparent.get_node("Decoration")
	grandparent.working_gridmap = gridmap
	switched_build_mode.emit(gridmap)


func select(button) -> void:
	for b in get_children():
		if not b is Button: continue
		b.disabled = false
	button.disabled = true
