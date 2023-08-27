extends OptionButton

@onready var map_node := get_node("/root/main/menu/world/Map")

func _ready() -> void:
	update_list()
	if item_count > 0:
		select(0)
		_on_map_selected(0)
	
	
	map_node.switched_map.connect(
		func(mapname):
			update_list()
			for i in item_count:
				if get_item_text(i) in mapname:
					select(i)
					break
	)


func update_list() -> void:
	clear()
	var dir = DirAccess
	if not dir.dir_exists_absolute("user://maps"):
		dir.make_dir_absolute("user://maps")
	
	for map_file in dir.get_files_at("user://maps"):
		add_item(map_file.replace(".save", ""))



func _on_map_selected(index: int) -> void:
	map_node.load_map(get_item_text(index)+".save")
