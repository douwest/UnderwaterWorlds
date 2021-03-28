extends Spatial

onready var terrain = $Terrain/MeshGenerator

onready var boids = $Boids
onready var spawn_position = $SpawnLocation
onready var Boid = preload("res://Animals/Fish.tscn")

export var spawn_boids: bool = false
export var num_boids: int = 100

func _ready():
	if spawn_boids:
		randomize()		
		for n in num_boids:
			var boid = Boid.instance()
			spawn(boid)

func spawn(boid: Boid) -> void:
	var x = spawn_position.transform.origin.x + rand_range(-4, 4)
	var y = spawn_position.transform.origin.y + rand_range(1, 5)
	var z = spawn_position.transform.origin.z + rand_range(-4, -4)
	boids.add_child(boid)
	boid.transform.origin = Vector3(x, y, z)
	while boid.test_move(boid.transform, Vector3(x, y, z)):
		x = spawn_position.transform.origin.x + rand_range(-4, 4)
		y = spawn_position.transform.origin.y + rand_range(1, 5)
		z = spawn_position.transform.origin.z + rand_range(-4, -4)
		boid.transform.origin = Vector3(x, y, z)
