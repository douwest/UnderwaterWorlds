extends Node

var noise_layer_1 = OpenSimplexNoise.new()
var noise_layer_2 = OpenSimplexNoise.new()
var noise_layer_3 = OpenSimplexNoise.new()

export var lacunarity = 1.4
export var octaves = 4
export var period = 32
export var persistence = 1.0
export var world_seed: int = 9

var height = 40

func _ready():
	noise_layer_1.set_period(period)
	noise_layer_1.set_lacunarity(lacunarity)
	noise_layer_1.set_persistence(persistence)
	noise_layer_1.set_octaves(octaves)
	noise_layer_1.set_seed(world_seed)
	
	noise_layer_2.set_period(period)
	noise_layer_2.set_lacunarity(lacunarity)
	noise_layer_2.set_persistence(persistence)
	noise_layer_2.set_octaves(octaves)
	noise_layer_2.set_seed(world_seed + 1)
	
	noise_layer_3.set_period(period)
	noise_layer_3.set_lacunarity(lacunarity)
	noise_layer_3.set_persistence(persistence)
	noise_layer_3.set_octaves(octaves)
	noise_layer_3.set_seed(world_seed + 2)

func get_density(x: float, y: float, z: float) -> float:
	var density = 0
	if y <= -height/2: 
		density = -1.0
	elif y >= height/2:
		density = 1.0
	else:
		density += noise_layer_1.get_noise_3dv(Vector3(x, y, z) * 4.03) * 0.25
		density += noise_layer_2.get_noise_3dv(Vector3(x, y, z) * 1.96) * 0.50
		density += noise_layer_3.get_noise_3dv(Vector3(x, y, z) * 1.01) * 1.02
	return density
