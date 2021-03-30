extends StaticBody

onready var arrayMesh = $Mesh
onready var collision_shape = $CollisionShape
onready var player_detection_zone = $PlayerDetectionZone

var offset = Vector3.ZERO
var coroutine = Thread.new()

signal generation_finished(mesh)

func generate():
	coroutine.start(self, "_generation_coroutine", offset, 2)
	var mesh = yield(self, "generation_finished")
	assign_collision_body(mesh)
	arrayMesh.mesh = mesh

func _generation_coroutine(o: Vector3):
	var mesh = MeshGenerator.generate(o)	
	emit_signal("generation_finished", mesh)
	
func assign_collision_body(mesh: ArrayMesh):
	var shape: Shape = mesh.create_trimesh_shape()
	collision_shape.set_shape(shape)

func _exit_tree():
	coroutine.wait_to_finish()

