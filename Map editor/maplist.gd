extends ItemList

var maps := []

func _ready() -> void:
	var dir = DirAccess
	if not dir.dir_exists_absolute("user://maps"):
		dir.make_dir_absolute("user://maps")
	
	for map_file in dir.get_files_at("user://maps"):
		$no_saved_maps.hide()
		maps.append(map_file.replace(".save", ""))
		add_item(map_file.replace(".save", ""))


func _on_item_activated(index: int) -> void:
	get_parent().load_map(maps[index])




func _on_item_selected(_index: int) -> void:
	get_node("../delete").disabled = false


func _on_delete_pressed() -> void:
	var confirm = ConfirmationDialog.new()
	add_child(confirm)
	
	confirm.confirmed.connect(
		func():
			DirAccess.remove_absolute("user://maps/"+maps[get_selected_items()[0]]+".save")
			maps.remove_at(get_selected_items()[0])
			remove_item(get_selected_items()[0])
			if item_count == 0:
				$no_saved_maps.show()
	)
	confirm.popup_centered()
	
