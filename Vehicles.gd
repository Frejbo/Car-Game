extends Node3D

var car : Info.cars
var prev_car_pos : Vector3

func _ready() -> void:
	# set player name
	if not is_multiplayer_authority(): return
	for Vehicle in get_children():
		Vehicle.get_node("PlayerName").text = Info.PlayerName
		Vehicle.get_node("PlayerName").hide()

func set_car(new_car : Info.cars):
	var vehicle : VehicleBody3D
	print(vehicle)
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
