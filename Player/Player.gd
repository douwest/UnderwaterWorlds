extends KinematicBody

var speed = 8
var ground_acceleration = 8
var air_acceleration = 2
var acceleration = ground_acceleration
var jump = 4.5
var gravity = 0
var stick_amount = 10
var mouse_sensitivity = 1

var direction = Vector3()
var velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()
var grounded = true

onready var fish = $fish

func ready() -> void:
	var new_y = 0
	while test_move(transform.translated(Vector3(0, 150, 0)), Vector3.ZERO):
		new_y = rand_range(-Density.height / 2, Density.height / 2)
		transform.origin.y = new_y

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity / 2
		rotation_degrees.x = clamp(rotation_degrees.x - event.relative.y * mouse_sensitivity / 2, -90, 90)
	
	direction.z = -Input.get_action_strength("move_forward") + Input.get_action_strength("move_backward")
	direction.x = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	direction.y = -Input.get_action_strength("move_down") + Input.get_action_strength("move_up")
	
	direction = direction.normalized().rotated(Vector3.UP, rotation.y)

func _physics_process(delta):

	if is_on_floor():
		gravity_vec = -get_floor_normal() * stick_amount
		acceleration = ground_acceleration
		grounded = true
	else:
		if grounded:
			gravity_vec = Vector3.ZERO
			grounded = false
		else:
			gravity_vec += Vector3.DOWN * gravity * delta
			acceleration = air_acceleration

	if Input.is_action_just_pressed("jump") and is_on_floor():
		grounded = false
		gravity_vec = Vector3.UP * jump

	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	movement.z = velocity.z + gravity_vec.z
	movement.x = velocity.x + gravity_vec.x
	movement.y = velocity.y - gravity_vec.y
	move_and_slide(movement, Vector3.UP)
