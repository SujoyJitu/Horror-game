extends Control

@onready var portrait: TextureRect = $Panel/MarginContainer/HBoxContainer/Portrait
@onready var name_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/NameLabel
@onready var text_label: RichTextLabel = $Panel/MarginContainer/HBoxContainer/VBoxContainer/TextLabel

signal dialogue_finished

var lines: Array = []
var index: int = 0

func _ready() -> void:
	visible = false

# lines = [{"who": "avi_shop", "name": "Avi", "text": "..."}, ...]
func start(new_lines: Array) -> void:
	lines = new_lines
	index = 0
	visible = true
	_show_line()

func _show_line() -> void:
	var line = lines[index]
	name_label.text = line.get("name", "")
	text_label.text = line.get("text", "")
	portrait.texture = _get_portrait(line.get("who", ""))

func _get_portrait(who: String) -> Texture2D:
	if who == "":
		return null
	var level = GameState.get_fear_level()
	# Sujoy ba bondhu: fear onujayi portrait
	var folder = who.split("_")[0]
	var path = "res://assets/chars/%s/%s_%s.jpg" % [folder, who, level]
	if ResourceLoader.exists(path):
		return load(path)
	# Fallback: calm
	var fallback = "res://assets/chars/%s/%s_calm.jpg" % [folder, who]
	if ResourceLoader.exists(fallback):
		return load(fallback)
	return null

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("ui_accept") or \
		(event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		index += 1
		if index >= lines.size():
			visible = false
			dialogue_finished.emit()
		else:
			_show_line()
		get_viewport().set_input_as_handled()
