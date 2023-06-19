extends Node3D

var prev_car_pos : Vector3
#signal car_changed
var car : Info.cars

func _ready() -> void:
	# set player name
	
	for Vehicle in get_children():
		Vehicle.visibility_changed.connect(update_car_variable)
		
		if not is_multiplayer_authority(): continue
		Vehicle.get_node("PlayerName").text = Info.PlayerName
		Vehicle.get_node("PlayerName").hide()
	
#	call_deferred(car_changed.connect(get_node("/root/main/menu/Lobby").update_card_info))

@warning_ignore("int_as_enum_without_cast")
func update_car_variable():
	var index := -1
	for Vehicle in get_children():
		index+=1
		if not Vehicle.visible: continue
		
		car = index



func set_car(new_car : Info.cars):
	var vehicle : VehicleBody3D
	car = new_car
	for node in get_children():
		if node.visible:
			prev_car_pos = node.position
		node.collision_layer = 0
		node.collision_mask = 0
		node.process_mode = Node.PROCESS_MODE_DISABLED
		node.hide()
	
	match new_car:
		Info.cars.SUV:
			vehicle = $SUV
		Info.cars.Sedan:
			vehicle = $Sedan
	
	vehicle.collision_layer = 1
	vehicle.collision_mask = 1
	vehicle.process_mode = Node.PROCESS_MODE_INHERIT
	vehicle.show()
	
	if prev_car_pos != null:
		vehicle.position = prev_car_pos
	
	# sometimes the game freezes when the user tries to drive forward without turning the wheel first. This is probably a bug with godot. To fix this I set the steering to a small amount when the car enters the scene. This amount steering should immidiatly disappear.
	vehicle.steering = .0001
	
	return vehicle
