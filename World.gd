extends Spatial

onready var chunk_manager = $ChunkManager

onready var spawn_position = $SpawnLocation
onready var Player = preload("res://Player/Player.tscn")

onready var seed_slider = $Control/VBoxContainer/SeedBox/Seed
onready var seed_label = $Control/VBoxContainer/SeedBox/Label

onready var lacunarity_slider = $Control/VBoxContainer/LacunarityBox/Lacunarity
onready var lacunarity_label = $Control/VBoxContainer/LacunarityBox/Label

onready var period_slider = $Control/VBoxContainer/PeriodBox/Period
onready var period_label = $Control/VBoxContainer/PeriodBox/Label

onready var octaves_slider = $Control/VBoxContainer/OctavesBox/Octaves
onready var octaves_label = $Control/VBoxContainer/OctavesBox/Label

onready var persistence_slider = $Control/VBoxContainer/PersistenceBox/Persistence
onready var persistence_label = $Control/VBoxContainer/PersistenceBox/Label

func _ready():
	seed_slider.set_value(Density.world_seed)
	lacunarity_slider.set_value(Density.lacunarity)
	period_slider.set_value(Density.period)
	octaves_slider.set_value(Density.octaves)
	persistence_slider.set_value(Density.persistence)
	
	var player = Player.instance()
	self.call_deferred('add_child', player)	

func _on_Seed_value_changed(value):
	Density.world_seed = value
	Density.init()
	seed_label.set_text('Seed: ' + str(Density.world_seed))	

func _on_Lacunarity_value_changed(value):
	Density.lacunarity = value
	Density.init()
	lacunarity_label.set_text('Lacunarity: ' + str(Density.lacunarity))		

func _on_Period_value_changed(value):
	Density.period = value
	Density.init()
	period_label.set_text('Period: ' + str(Density.period))

func _on_Persistence_value_changed(value):
	Density.persistence = value
	Density.init()
	persistence_label.set_text('Persistence: ' + str(Density.persistence))

func _on_Octaves_value_changed(value):
	Density.octaves = value
	Density.init()
	octaves_label.set_text('Octaves: ' + str(Density.octaves))	

func _on_Rerender_pressed():
	chunk_manager.generate()
