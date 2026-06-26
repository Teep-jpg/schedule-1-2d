extends Node2D

# Growth stages
var growth_stages = [
	"res://Plant/Seed-Tiny.png",
	"res://Plant/Seed-Small.png",
	"res://Plant/Seed-Medium.png",
	"res://Plant/Seed-full.png"
]

var bud_scene = preload("res://Plant/Bud.tscn")
var buds_harvested = 0
var total_buds = 8
var current_stage = 0
var growth_percent = 0.0
var water_level = 100.0

var growth_scales = [
	Vector2(1.0, 1.0),  # Tiny seedling
	Vector2(1.3, 1.3),  # Small
	Vector2(1.9, 1.9),  # Medium
	Vector2(2.3, 2.3)   # Full grown
]

var growth_positions = [
	Vector2(602, 320),   # Tiny
	Vector2(602, 264),   # Small
	Vector2(596, 231),   # Medium
	Vector2(626, 248)    # Full grown
]

# How fast water drains and plant grows (per second)
var water_drain_rate = 1.0
var growth_rate = 10.5

@onready var plant = $Plant
@onready var bud = $Bud
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
		# Random position around the plant
		bud.position = plant.position + Vector2(
	randf_range(-80, 80),
	randf_range(-150, -30)
)
	bud.connect("bud_harvested", _on_bud_harvested)

func _on_bud_harvested():
	buds_harvested += 1
	print("Buds harvested: ", buds_harvested, "/", total_buds)

func update_growth_stage():
	var new_stage = int(growth_percent / 33.33)
	new_stage = clamp(new_stage, 0, growth_stages.size() - 1)
	if new_stage != current_stage:
		current_stage = new_stage
		plant.texture = load(growth_stages[current_stage])
		plant.position = growth_positions[current_stage]
		plant.scale = growth_scales[current_stage]
		if current_stage == growth_stages.size() - 1:
			spawn_buds()
