extends AspectRatioContainer

func set_icon(car:Info.cars):
	$HBoxContainer/TextureRect.texture = load(Info.car_icons[car])

var display_name : String:
	set(val):
		$HBoxContainer/name.text = val
	get:
		return display_name
