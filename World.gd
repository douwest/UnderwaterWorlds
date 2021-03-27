extends Spatial

onready var terrain = $Terrain/MeshGenerator
onready var seed_slider = $Control/VBoxContainer/SeedHBox/SeedSlider
onready var period_slider = $Control/VBoxContainer/PeriodHBox/PeriodSlider
onready var lacunarity_slider = $Control/VBoxContainer/LacunarityHBox/LacunaritySlider
onready var persistence_slider = $Control/VBoxContainer/PersistenceHBox/PersistenceSlider
onready var octaves_slider = $Control/VBoxContainer/OctavesHBox/OctavesSlider
onready var blend_slider = $Control/VBoxContainer/BlendHBox/BlendSlider

onready var seed_label = $Control/VBoxContainer/SeedHBox/SeedLabel
onready var period_label = $Control/VBoxContainer/PeriodHBox/PeriodLabel
onready var lacunarity_label = $Control/VBoxContainer/LacunarityHBox/LacunarityLabel
onready var persistence_label = $Control/VBoxContainer/PersistenceHBox/PersistenceLabel
onready var octaves_label = $Control/VBoxContainer/OctavesHBox/OctavesLabel
onready var blend_label = $Control/VBoxContainer/BlendHBox/BlendLabel

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

func _on_OctavesSlider_value_changed(value):
	terrain.set_octaves(value)
	octaves_label.set_text('Octaves: ' + str(value))

func _on_PersistenceSlider_value_changed(value):
	terrain.set_persistence(value)
	persistence_label.set_text('Persistence: ' + str(value))

func _on_PeriodSlider_value_changed(value):
	terrain.set_period(value)
	period_label.set_text('Period: ' + str(value))	

func _on_LacunaritySlider_value_changed(value):
	terrain.set_lacunarity(value)
	lacunarity_label.set_text('Lacunarity: ' + str(value))	

func _on_SeedSlider_value_changed(value):
	terrain.set_seed(value)
	seed_label.set_text('Seed: ' + str(value))	

func _on_BlendSlider_value_changed(value):
	terrain.set_blend(value)
	blend_label.set_text('Blend: ' + str(value))
