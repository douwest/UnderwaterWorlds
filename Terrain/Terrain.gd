extends StaticBody

onready var mesh_generator = $MeshGenerator
onready var collision_shape = $CollisionShape
onready var player_detection_zone = $PlayerDetectionZone

var offset = Vector3.ZERO

func _ready():
	mesh_generator.generate(offset)
	
func _on_MeshGenerator_generation_finished(mesh: ArrayMesh):
	var shape: Shape = mesh.create_trimesh_shape()
	collision_shape.set_shape(shape)
