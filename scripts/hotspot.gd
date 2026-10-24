extends Area2D

# Inspector theke set korbe
@export var hotspot_name: String = "Hotspot"
@export var shape_size: Vector2 = Vector2(200, 200)

signal clicked(hotspot_name)

func _ready() -> void:
	input_pickable = true
	# Collision shape code diye banai
	var shape := RectangleShape2D.new()
	shape.size = shape_size
	var col := CollisionShape2D.new()
	col.shape = shape
	add_child(col)

func _input_event(_viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit(hotspot_name)
