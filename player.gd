extends Node3D

@export var STEERING_RATE : float = .35
@export var STEERING_SENSITIVITY : float = .35
@export var ENGINE_POWER : float = 400
@export var ENGINE_SPEED : float = 30
const MOUSE_SENSITIVITY := .4
const ZOOM_SENSITIVITY := .2

var Vehicle

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())
	set_car(Info.cars.SUV)

func _ready() -> void:
	Info.game_started.connect(start)
	$CanvasLayer/speed.hide()
	if not is_multiplayer_authority():
		$CanvasLayer.hide()


func start() -> void:
	$CanvasLayer/speed.show()
	$CanvasLayer/carSelector.hide()
	process_mode = Node.PROCESS_MODE_INHERIT
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if is_multiplayer_authority():
		$camera_rotation_x/camera_rotation_y/Camera3D.current = true
	# sometimes the game freezes when the user tries to drive forward without turning the wheel first. This is probably a bug with godot. To fix this I set the steering to a small amount when the car enters the scene. This amount steering should immidiatly disappear.
	Vehicle.steering = .0001


func set_car(car : Info.cars):
	Vehicle = $Vehicles.set_car(car)


var speed := 0.0
func _physics_process(delta: float) -> void:
	
	
	# speed UI
	if is_multiplayer_authority():
		
		# calculate speed and show on UI
		speed = -get_velocity().z * 3.6
		$CanvasLayer/speed.text = str(abs(round(speed))) + " Km/h"
		
		
		if Input.is_action_pressed("forward"):
			set_brake_force(0)
			set_engine_force(-ENGINE_POWER * ((ENGINE_SPEED / abs(get_velocity().z * 3.6)) + 1)) # Formler för att bilen ska gasa mindre ju snabbare man kör
		elif Input.is_action_pressed("back"):
			if speed > 0:
				#bromsa
				set_brake_force(7)
			else:
				#backa
				set_brake_force(0)
				set_engine_force(ENGINE_POWER * .4 * ((ENGINE_SPEED / abs(get_velocity().z * 3.6)) + 1))
		else:
			set_engine_force(0)
		engine_sound(abs(speed))
		
		if Input.is_action_pressed("left"):
			Vehicle.steering = clamp(Vehicle.steering + STEERING_SENSITIVITY * delta, -STEERING_RATE, STEERING_RATE)
		elif Input.is_action_pressed("right"):
			Vehicle.steering = clamp(Vehicle.steering - STEERING_SENSITIVITY * delta, -STEERING_RATE, STEERING_RATE)
		else:
			Vehicle.steering *= 300 * STEERING_SENSITIVITY * delta
	
	
	
	for wheel in [Vehicle.get_node("FL wheel"), Vehicle.get_node("FR wheel"), Vehicle.get_node("BL wheel"), Vehicle.get_node("BR wheel")]:
		# Drifting particles
		if wheel.get_skidinfo() < 1: # skidding
			dirt_particle(wheel)
		
		# Brake on ground
		if wheel.get_contact_body() != null and wheel.get_contact_body().is_in_group("Ground"):
			wheel.brake = 5 * wheel.get_skidinfo()
			Vehicle.engine_force *= 119 * delta
			dirt_particle(wheel)
	
	
	# place camera at car:
	$camera_rotation_x.position = Vehicle.position + Vector3(0, 1, 0)
	
	# reset if car is outside world:
	if Vehicle.position.y < -5:
		Vehicle.position.y = 5



func dirt_particle(wheel : VehicleWheel3D):
	if abs(speed) < 1: return
	var particle = preload("res://Drift particles.tscn").instantiate()
	if wheel.get_skidinfo() < .95:
		# If not skidding, but for example driving on dirt, the lifetime should not be multiplied by 0
		particle.lifetime = particle.lifetime * (1 - wheel.get_skidinfo())
		particle.amount = clamp(round(particle.amount * (1 - wheel.get_skidinfo())), 1, particle.amount)
	wheel.add_child(particle)

@onready var engine_volume = 0#$VehicleBody3D/engine.volume_db
func engine_sound(acceleration):
	Vehicle.get_node("engine").pitch_scale = clamp(acceleration / 30, .4, 2.7)
	Vehicle.get_node("engine").volume_db = engine_volume + clamp(acceleration / 2, 0, 20)


func get_velocity(object = Vehicle) -> Vector3:
	var b = object.transform.basis
	var v_len = object.linear_velocity.length()
	var v_nor = object.linear_velocity.normalized()
	
	var velocity := Vector3.ZERO
	velocity.x = b.x.dot(v_nor) * v_len
	velocity.y = b.y.dot(v_nor) * v_len
	velocity.z = b.z.dot(v_nor) * v_len
	return velocity

func set_engine_force(force:float) -> void:
	engine_sound(force)
	Vehicle.engine_force = force

func set_brake_force(force:float) -> void:
	for wheel in Vehicle.get_children():
		if not wheel is VehicleWheel3D: continue
		wheel.brake = force



func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# camera movement
		
		# vertically
		$camera_rotation_x/camera_rotation_y.rotate_z(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY))
		if $camera_rotation_x/camera_rotation_y.rotation_degrees.z > 85: $camera_rotation_x/camera_rotation_y.rotation_degrees.z = 85
		if $camera_rotation_x/camera_rotation_y.rotation_degrees.z < -5: $camera_rotation_x/camera_rotation_y.rotation_degrees.z = -5
		# horizontally
		$camera_rotation_x.global_rotate(Vector3(0,1,0), deg_to_rad(event.relative.x * -MOUSE_SENSITIVITY))
	
	if event.is_action_pressed("ESC"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# camera zooming
	if event.is_action("scroll_up"):
		# zoom in
		if $camera_rotation_x/camera_rotation_y/Camera3D.position.x <= 2: return
		$camera_rotation_x/camera_rotation_y/Camera3D.position.x -= ZOOM_SENSITIVITY
	if event.is_action("scroll_down"):
		# zoom out
		if $camera_rotation_x/camera_rotation_y/Camera3D.position.x >= 15: return
		$camera_rotation_x/camera_rotation_y/Camera3D.position.x += ZOOM_SENSITIVITY
