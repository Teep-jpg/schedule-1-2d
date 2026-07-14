extends Node2D

var growth_stages = [
	"res://Plant/Seed-Tiny.png",
	"res://Plant/Seed-full.png"
]

var bud_scene = preload("res://Plant/bud.tscn")
var total_buds = 8
var buds_harvested = 0
var buds_spawned = false

var current_stage = 0
var growth_percent = 0.0
var water_level = 0.0
var quality = 0.5
var speed_grow_used = false

var growth_scales = [
	Vector2(1.0, 1.0),
	Vector2(2.3, 2.3)
]

var growth_positions = [
	Vector2(602, 320),
	Vector2(626, 248)
]

var water_drain_rate = 0.6
var growth_rate = 0.4

@onready var plant = $Plant
@onready var water_bar = $UI/Bars/WaterBar
@onready var growth_bar = $UI/Bars/GrowthBar

func _ready():
	plant.texture = load(growth_stages[current_stage])

func _process(delta):
	if water_level > 0:
		water_level -= water_drain_rate * delta
		water_level = clamp(water_level, 0, 100)
		
		if water_level > 0:
			growth_percent += growth_rate * delta
			growth_percent = clamp(growth_percent, 0, 100)
			update_growth_stage()
	
	water_bar.value = water_level
	growth_bar.value = growth_percent

func spawn_buds():
	for i in range(total_buds):
		var bud = bud_scene.instantiate()
		$Buds.add_child(bud)
		bud.position = plant.position + Vector2(
			randf_range(-80, 80),
			randf_range(-150, -30)
		)
		bud.connect("bud_harvested", _on_bud_harvested)

func _on_bud_harvested():
	buds_harvested += 1
	if buds_harvested >= total_buds:
		print("All buds harvested! Quality: ", get_quality_tier())
		buds_harvested = 0
		reset_plant()

func get_quality_tier() -> String:
	if quality < 0.2: return "Trash"
	elif quality < 0.4: return "Poor"
	elif quality < 0.6: return "Standard"
	elif quality < 0.8: return "Premium"
	else: return "Heavenly"

func reset_plant():
	growth_percent = 0.0
	water_level = 0.0
	quality = 0.5
	speed_grow_used = false
	buds_spawned = false
	current_stage = 0
	plant.modulate = Color(1, 1, 1)
	plant.texture = load(growth_stages[0])
	plant.position = growth_positions[0]
	plant.scale = growth_scales[0]

func update_growth_stage():
	var new_stage = int(growth_percent / 100)
	new_stage = clamp(new_stage, 0, growth_stages.size() - 1)
	if new_stage != current_stage:
		current_stage = new_stage
		plant.texture = load(growth_stages[current_stage])
		plant.position = growth_positions[current_stage]
		plant.scale = growth_scales[current_stage]
	if current_stage == growth_stages.size() - 1 and not buds_spawned:
		buds_spawned = true
		spawn_buds()
