extends Spatial

onready var Terrain = preload("res://Terrain/Terrain.tscn")

onready var edge_length = 3

var neighbours = [
	Vector3(0, 0,-1),
	Vector3(0,0,1),
	Vector3(1,0,-1),
	Vector3(1,0,0),
	Vector3(1,0,1),
	Vector3(-1,0,-1),
	Vector3(-1,0,0),
	Vector3(-1,0,1)
]

var current_chunk = null
var chunk_buffer = []

func _ready():
	init(transform.origin)

func init(origin_position: Vector3):
	current_chunk = Terrain.instance()
	current_chunk.offset = Vector3(origin_position.x, 0, origin_position.z)
	current_chunk.generate(true) 
	current_chunk.connect("generation_finished", self, "generate_neighbours")
	self.call_deferred('add_child', current_chunk)
	chunk_buffer.append(current_chunk.offset)

func generate_chunk(origin_position: Vector3):
	var chunk = Terrain.instance()
	chunk.offset = Vector3(origin_position.x, 0, origin_position.z)
	if chunk != current_chunk:
		chunk.generate(false)
	else:
		chunk.generate(true)
	self.call_deferred('add_child', chunk)
	chunk_buffer.append(chunk.offset)
	return chunk

func generate_neighbours():
	print(chunk_buffer)
	var origin_pos = current_chunk.offset
	for neighbour in neighbours:
		var neigh_pos = Vector3(origin_pos.x + neighbour.x, 0, origin_pos.z + neighbour.z)
		if !chunk_buffer.has(neigh_pos):
			var chunk = generate_chunk(neigh_pos)
			

func set_current_chunk(chunk: StaticBody):
	current_chunk = chunk
	generate_neighbours()
