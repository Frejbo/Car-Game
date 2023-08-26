extends Camera3D

const MOUSE_SENSITIVITY = .3
const MOVEMENT_SPEED = 2
const BOOST_MULTIPLIER = 5

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotateCamera(event)


func rotateCamera(mouseEvent):
	get_parent().rotate_y(deg_to_rad(mouseEvent.relative.x * -1) * MOUSE_SENSITIVITY)
	rotate_x(deg_to_rad(mouseEvent.relative.y * -1) * MOUSE_SENSITIVITY)
	if rotation_degrees.x < -90: rotation_degrees.x = -90
	if rotation_degrees.x > 90: rotation_degrees.x = 90

func moveCamera(delta):
	var boost : float = 1
	if Input.is_action_pressed("map_editor_boost"):
		boost = BOOST_MULTIPLIER
	var fb : float = Input.get_axis("map_editor_forward", "map_editor_back")
	var lr : float = Input.get_axis("map_editor_left", "map_editor_right")
	var du : float = Input.get_axis("map_editor_down", "map_editor_up")
	var input_vector := Vector3(lr, du, fb).normalized()
	get_parent().position += global_transform.basis.z * input_vector.z * MOVEMENT_SPEED * delta * boost
	get_parent().position += global_transform.basis.x * input_vector.x * MOVEMENT_SPEED * delta * boost
	get_parent().position += global_transform.basis.y * input_vector.y * MOVEMENT_SPEED * delta * boost


func _process(delta):
	moveCamera(delta)

