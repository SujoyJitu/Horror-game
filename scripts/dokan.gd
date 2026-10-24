extends Node2D

@onready var dialogue: Control = $UI/DialogueBox
@onready var avi_spot: Area2D = $AviSpot
@onready var battery_spot: Area2D = $BatterySpot
@onready var board_spot: Area2D = $BoardSpot

var avi_talked: bool = false

func _ready() -> void:
	avi_spot.clicked.connect(_on_hotspot)
	battery_spot.clicked.connect(_on_hotspot)
	board_spot.clicked.connect(_on_hotspot)

func _on_hotspot(hs_name: String) -> void:
	print("Clicked: ", hs_name)
	if dialogue.visible:
		return
	match hs_name:
		"avi":
			_talk_to_avi()
		"battery":
			_buy_battery()
		"board":
			_look_board()

func _talk_to_avi() -> void:
	avi_talked = true
	GameState.add_clue("avi_warning")
	dialogue.start([
		{"who": "avi_shop", "name": "Avi", "text": "Apnara... villa-te jachchen?"},
		{"who": "avi_shop", "name": "Avi", "text": "Raat hoar age berie jaben."},
		{"who": "avi_shop", "name": "Avi", "text": "Ar... 10 number keu gunben na."},
		{"who": "sujoy", "name": "Sujoy", "text": "10 number? Mane ki?"},
		{"who": "avi_shop", "name": "Avi", "text": "..."},
		{"who": "sujoy", "name": "Sujoy", "text": "Lokta-ke kothao dekhechi mone hocche..."},
	])
	GameState.add_fear(10)

func _buy_battery() -> void:
	if GameState.has_item("battery_1"):
		dialogue.start([{"who": "sujoy", "name": "Sujoy", "text": "Battery ekta niyechi already."}])
		return
	GameState.add_item("battery_1")
	dialogue.start([{"who": "sujoy", "name": "Sujoy", "text": "Ekta battery kinlam. Kaje lagbe."}])

func _look_board() -> void:
	GameState.add_clue("poster_10_friends")
	dialogue.start([
		{"who": "sujoy", "name": "Sujoy", "text": "Purano poster... 10 jon dariye ache."},
		{"who": "sujoy", "name": "Sujoy", "text": "Amra to 9 jon."},
	])
	GameState.add_fear(8)
