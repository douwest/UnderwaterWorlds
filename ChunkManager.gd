extends Spatial

onready var Terrain = preload("res://Terrain/Terrain.tscn")

onready var offset = Density.width
onready var edge_length = 1
onready var height = 1

func generate():
	for child in get_children():
		self.call_deferred('remove_child', child)
	
	for x in edge_length:
		for y in height:
			for z in edge_length:
				var chunk = Terrain.instance()
				chunk.offset = Vector3(x * offset, y * offset, z * offset)
				self.call_deferred('add_child', chunk)

