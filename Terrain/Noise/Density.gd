extends Node

var noise_layer = OpenSimplexNoise.new()

export var lacunarity = 1.7
export var octaves = 5
export var period = 64
export var persistence = 1.6
export var world_seed: int = 6

export var absolute_floor = -16
export var absolute_ceil = 16

var height = 64
var width = 64

func _ready(): 
	init()

func init():
	noise_layer.set_period(period)
	noise_layer.set_lacunarity(lacunarity)
	noise_layer.set_persistence(persistence)
	noise_layer.set_octaves(octaves)
	noise_layer.set_seed(world_seed)

func get_density(x: float, y: float, z: float) -> float:
	var density = y
	if y <= absolute_floor:
		return -1.0
	elif y >= absolute_ceil:
		return 1.0
	density += noise_layer.get_noise_3dv(Vector3(x, y, z) * 4.03) * 0.25 * x
	density += noise_layer.get_noise_3dv(Vector3(x, y, z) * 1.96) * 0.50 * x
	density += noise_layer.get_noise_3dv(Vector3(x, y, z) * 1.01) * 1.02 * x
	density += noise_layer.get_noise_3dv(Vector3(x, y, z) * 0.60) * 2.08 * x
	return density
