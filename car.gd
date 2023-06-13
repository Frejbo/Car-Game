extends Node3D

const STEERING_RATE := .35
const STEERING_SENSITIVITY := .35
const ENGINE_POWER := 400
const ENGINE_SPEED := 30
const MOUSE_SENSITIVITY := .4
const ZOOM_SENSITIVITY := .2

@onready var Vehicle = $VehicleBody3D

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	Info.game_started.connect(start)
	print("Ready! " , multiplayer.get_unique_id())

func start() -> void:
	$VehicleBody3D/engine.playing = true
	process_mode = Node.PROCESS_MODE_INHERIT
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if is_multiplayer_authority():
		$camera_rotation_x/camera_rotation_y/Camera3D.current = true
		$VehicleBody3D/PlayerName.hide()
		$VehicleBody3D/PlayerName.text = Info.PlayerName
	else:
		$CanvasLayer.hide()

#func place_car():
#	var startPositions = get_parent().get_parent().get_node("map/startPositions")
#	var new_transform = await startPositions.get_start_position(multiplayer.get_unique_id())
#	print(new_transform)
#	if new_transform == null:
#		OS.alert("Server is full or already running.")
#		get_tree().quit()
#
#	global_rotation = new_transform[0]
#	position = new_transform[1]

var speed := 0.0
func _physics_process(delta: float) -> void:
	
	for wheel in [$"VehicleBody3D/FL wheel", $"VehicleBody3D/FR wheel", $"VehicleBody3D/BL wheel", $"VehicleBody3D/BR wheel"]:
		# Drifting particles
		if wheel.get_skidinfo() < 1: # skidding
			dirt_particle(wheel)
		
		# Brake on ground
		if wheel.get_contact_body() != null and wheel.get_contact_body().is_in_group("Ground"):
			wheel.brake = 5 * wheel.get_skidinfo()
			Vehicle.engine_force *= .1 # TODO doesnt work
			dirt_particle(wheel)
	
	
	
	if not is_multiplayer_authority(): return
	
	
	
	if Input.is_action_pressed("forward"):
		set_brake_force(0)
		set_engine_force(-ENGINE_POWER * ((ENGINE_SPEED / abs(get_velocity().z * 3.6)) / 1)) # Formler för att bilen ska gasa mindre ju snabbare man kör
	elif Input.is_action_pressed("back"):
		if speed > 0:
			#bromsa
			set_brake_force(7)
		else:
			#backa
			set_brake_force(0)
			set_engine_force(ENGINE_POWER*.5 * ((ENGINE_SPEED / abs(get_velocity().z * 3.6)) / 1))
	else:
		set_engine_force(0)
	engine_sound(speed)
	
	if Input.is_action_pressed("left"):
		Vehicle.steering = clamp(Vehicle.steering + STEERING_SENSITIVITY * delta, -STEERING_RATE, STEERING_RATE)
	elif Input.is_action_pressed("right"):
		Vehicle.steering = clamp(Vehicle.steering - STEERING_SENSITIVITY * delta, -STEERING_RATE, STEERING_RATE)
	else:
		Vehicle.steering *= 1.9 * STEERING_SENSITIVITY
	
	
	
	
	# place camera at car:
	$camera_rotation_x.position = Vehicle.position + Vector3(0, 1, 0)
	
	# reset if car is outside world:
	if Vehicle.position.y < -5:
		Vehicle.position.y = 5



func dirt_particle(wheel : VehicleWheel3D):
	if speed < 1: return
	var particle = preload("res://Drift particles.tscn").instantiate()
	if wheel.get_skidinfo() < .95:
		# If not skidding, but for example driving on dirt, the lifetime should not be multiplied by 0
		particle.lifetime = particle.lifetime * (1 - wheel.get_skidinfo())
	wheel.add_child(particle)

@onready var engine_volume = $VehicleBody3D/engine.volume_db
func engine_sound(acceleration):
	$VehicleBody3D/engine.pitch_scale = clamp(acceleration / 30, .4, 2.7)
	$VehicleBody3D/engine.volume_db = engine_volume + clamp(acceleration / 2, 0, 20)


func _process(_delta: float) -> void:
	speed = -get_velocity().z * 3.6
	$CanvasLayer/speed.text = str(abs(round(speed))) + " Km/h"

func get_velocity(object = $VehicleBody3D) -> Vector3:
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
	for wheel in Vehicle.get_children():
		if not wheel is VehicleWheel3D: continue
		wheel.engine_force = force
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
