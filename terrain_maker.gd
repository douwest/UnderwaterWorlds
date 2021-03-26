tool

extends Spatial


onready var terrain = $terrain
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

func _ready():
	seed_slider.set_value(terrain.s)
	period_slider.set_value(terrain.period)
	lacunarity_slider.set_value(terrain.lacunarity)
	persistence_slider.set_value(terrain.persistence)
	octaves_slider.set_value(terrain.octaves)
	blend_slider.set_value(terrain.blend_parameter)

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
