extends OptionButton

@onready var car:int = selected

func _ready() -> void:
	var config = ConfigFile.new()
	config.load("user://config.cfg")
	selected = config.get_value("last_used", "car", 0)

func _on_item_selected(index: int) -> void:
	if not is_multiplayer_authority():
		return
	
	if Info.cars.size() <= index:
		OS.alert("Something went wrong when selecting car " + str(index) + ". Please report this.")
		car = selected
		return
	
	car = index
	
	get_parent().get_parent().set_car(car)
