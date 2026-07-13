extends Sprite2D

var start_position: Vector2
var dragging = false
var rotation_speed = 150.0
var grow_room: Node2D

func _ready():
	start_position = position
	grow_room = get_parent()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Check if clicking on the watering can
				var local_pos = to_local(event.position)
				if get_rect().has_point(local_pos):
					dragging = true
			else:
				dragging = false
	
	if event is InputEventMouseMotion:
		if dragging:
			position = event.position

func _process(delta):
	if dragging:
		rotation_degrees = lerp(rotation_degrees, -90.0, delta * 2.0)
		
		# Check if tilted enough and close enough to plant to water
		if abs(rotation_degrees) > 60.0:
			var distance = position.distance_to(grow_room.plant.position)
			if distance < 200.0:
				grow_room.water_level += 10 * delta
				grow_room.water_level = clamp(grow_room.water_level, 0, 100)
	else:
		rotation_degrees = lerp(rotation_degrees, 0.0, delta * 2.0)
		position = lerp(position, start_position, delta * 5.0)
