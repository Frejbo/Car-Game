extends Control




func load_map(mapName : String) -> void: # filename and name is the same at the moment
	
	var data := {}
	var file = FileAccess.open("user://maps/"+mapName+".save", FileAccess.READ)
	data = file.get_var()
	file.close()
	
	var editor = preload("res://Map editor/map_editor_main.tscn").instantiate()
	editor.mapName = mapName
	add_child(editor)
	editor.load_map(data)
	hide()


func new_map(mapName : String) -> void:
	var editor = preload("res://Map editor/map_editor_main.tscn").instantiate()
	editor.mapName = mapName
	add_child(editor)
	hide()
