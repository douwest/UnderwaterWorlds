extends Spatial

onready var Terrain = preload("res://Terrain/Terrain.tscn")

onready var chunk_width = Density.width
onready var edge_length = 2

func _ready():
	generate()

func generate():
	for x in edge_length:
		for y in edge_length:
			for z in edge_length:
				var chunk = Terrain.instance()
				chunk.offset = Vector3(x * chunk_width, y * chunk_width, z * chunk_width)
				chunk.generate()
				self.call_deferred('add_child', chunk)

func chunk_generated(chunk: StaticBody):
	pass
