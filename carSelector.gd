extends OptionButton

@onready var car:int = selected

func _ready() -> void:
	pass

func _on_item_selected(index: int) -> void:
	if not is_multiplayer_authority():
		print("hsakdjaks")
		return
	
	if Info.cars.size() <= index:
		OS.alert("Something went wrong when selecting car " + str(index) + ". Please report this.")
		car = selected
		return
	
	car = index
	
	get_parent().get_parent().set_car(car)
