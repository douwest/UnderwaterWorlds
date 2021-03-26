tool

extends Position3D

export var auto_rotate: bool = true
export var rotation_speed: float = 1.0

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		auto_rotate = !auto_rotate
	if Input.is_action_pressed("camera_rotate_left"):
		transform = transform.rotated(Vector3(0,1,0), rotation_speed * delta)
	if Input.is_action_pressed("camera_rotate_right"):
		transform = transform.rotated(Vector3(0,1,0), -rotation_speed * delta)
	if auto_rotate:
		transform = transform.rotated(Vector3(0,1,0), rotation_speed * delta)
