extends Node

# ===== Signals =====
signal fear_changed(value)
signal item_added(item_id)
signal trust_changed(friend_id, value)

# ===== Core state =====
var current_chapter: int = 1
var loop_count: int = 7          # twist: 7th loop
var fear: float = 0.0            # 0 - 100
var time_minutes: int = 18 * 60  # 6:00 PM, minute-e
const SUNRISE_MINUTES: int = 5 * 60 + 30 + 24 * 60  # 5:30 AM porer din

# ===== Friends =====
const FRIENDS = ["arafat", "waafe", "abir", "pritam", "joy",
				 "bishal", "mong", "tahamid"]
var trust: Dictionary = {}
var missing: Array = []          # gayeb bondhura

# ===== Inventory & clues =====
var inventory: Array = []
var clues: Array = []
var battery: int = 100

func _ready() -> void:
	for f in FRIENDS:
		trust[f] = 50

# ----- Fear -----
func add_fear(amount: float) -> void:
	fear = clamp(fear + amount, 0.0, 100.0)
	fear_changed.emit(fear)

func get_fear_level() -> String:
	if fear < 35.0:
		return "calm"
	elif fear < 70.0:
		return "uneasy"
	return "terrified"

# ----- Inventory -----
func add_item(item_id: String) -> void:
	if item_id not in inventory:
		inventory.append(item_id)
		item_added.emit(item_id)

func has_item(item_id: String) -> bool:
	return item_id in inventory

func add_clue(clue_id: String) -> void:
	if clue_id not in clues:
		clues.append(clue_id)

# ----- Trust -----
func change_trust(friend_id: String, amount: int) -> void:
	if friend_id in trust:
		trust[friend_id] = clamp(trust[friend_id] + amount, 0, 100)
		trust_changed.emit(friend_id, trust[friend_id])

# ----- Head Count (core clue) -----
func head_count() -> int:
	var present = FRIENDS.size() + 1 - missing.size()  # + Sujoy
	# Kokhono 9, kokhono 10 dekhabe (twist)
	if missing.is_empty() and randf() < 0.4:
		return present + 1
	return present

# ----- Time -----
func advance_time(minutes: int) -> void:
	time_minutes += minutes

func get_time_string() -> String:
	var m = time_minutes % (24 * 60)
	var h = m / 60
	var mm = m % 60
	var suffix = "AM" if h < 12 else "PM"
	var h12 = h % 12
	if h12 == 0:
		h12 = 12
	return "%d:%02d %s" % [h12, mm, suffix]
