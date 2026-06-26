extends Area2D

signal bud_harvested

func _ready():
	input_pickable = true
	connect("input_event", _on_input_event)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("bud_harvested")
			queue_free()
			get_viewport().set_input_as_handled()
