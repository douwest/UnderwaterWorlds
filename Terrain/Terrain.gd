extends StaticBody

onready var arrayMesh = $Mesh
onready var collision_shape = $CollisionShape
onready var player_detection_zone = $Area/PlayerDetectionZone

var offset = Vector3.ZERO
var coroutine = Thread.new()

onready var Plant_A = preload("res://Terrain/Assets/UnderwaterPlant.tscn")

signal mesh_generated(mesh)
signal generation_finished()
signal player_entered(chunk)

func generate(is_disabled: bool):
	var offset_width = Vector3(offset.x * Density.width, offset.y * Density.width, offset.z * Density.width)
	coroutine.start(self, "_generation_coroutine", [offset_width], 1)
	
	var mesh = yield(self, "mesh_generated")
	assign_collision_body(mesh)
	arrayMesh.mesh = mesh
	
	generate_plants()
	
	if is_disabled:
		disable_detection_zone()
	else:
		enable_detection_zone()
	
	emit_signal("generation_finished")

func _generation_coroutine(offset: Array):
	var mesh = MeshGenerator.generate(offset[0])
	emit_signal("mesh_generated", mesh)

func generate_plants():
	var number_of_plants = randi() % 30
	for n in number_of_plants:
		var plant = Plant_A.instance()
		var random_position = Vector3(offset.x * Density.width + rand_range(0, Density.width), -20, offset.z * Density.width + rand_range(0, Density.width))
		var above_random_position = Vector3(random_position.x, 20, random_position.z)
		var ray = get_world().get_direct_space_state().intersect_ray(above_random_position, random_position)
		if !ray.empty():
			var plant_scale = rand_range(0.3, 2.5)
			plant.transform = plant.transform.scaled(Vector3(plant_scale, plant_scale, plant_scale))
			plant.transform = plant.transform.rotated(Vector3(0, 1, 0), deg2rad(randi() % 360))
			plant.transform.origin.y = plant.transform.origin.y + 1.9
			plant.transform.origin = ray['position']
			self.call_deferred('add_child', plant)

		
func assign_collision_body(mesh: ArrayMesh):
	var shape: Shape = mesh.create_trimesh_shape()
	collision_shape.set_shape(shape)
	player_detection_zone.translate(offset * 32)

func _exit_tree():
	coroutine.wait_to_finish()

func _on_Area_body_entered(body):
	get_parent().set_current_chunk(self)

func disable_detection_zone():
	player_detection_zone.set_disabled(true)

func enable_detection_zone():
	player_detection_zone.set_disabled(false)
