extends Node2D
class_name DiningTable

@export_subgroup("References")
@export var seat_1 : Seat
@export var seat_2 : Seat
@export var breakfast_1 : Breakfast
@export var breakfast_2 : Breakfast

@export_subgroup("Audio Settings")
@export var plate_drop_sfx_name : String = "plate_drop"

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(seat_1, "seat_1 is missing")
	assert(seat_2, "seat_2 is missing")
	assert(breakfast_1, "breakfast_1 is missing")
	assert(breakfast_2, "breakfast_2 is missing")
	# Connect signals
	seat_1.occupant_sat.connect(func(node:Node):
		if node is Player:
			if breakfast_1: breakfast_1.toggle_eatable(true)
		)
	seat_1.occupant_stood_up.connect(func(node:Node):
		if node is Player:
			if breakfast_1: breakfast_1.toggle_eatable(false)
		)
	seat_2.occupant_sat.connect(func(node:Node):
		if node is Player:
			if breakfast_2: breakfast_2.toggle_eatable(true)
		)
	seat_2.occupant_stood_up.connect(func(node:Node):
		if node is Player:
			if breakfast_2: breakfast_2.toggle_eatable(false)
		)
	# Initialize
	breakfast_1.hide()
	breakfast_2.hide()

# ==================================================================================================
#                Dining table methods
# ==================================================================================================
func place_breakfast():
	breakfast_1.show()
	if seat_1.is_occupied() and seat_1.get_occupant() is Player:
		breakfast_1.toggle_eatable(true)
	breakfast_2.show()
	if seat_2.is_occupied() and seat_1.get_occupant() is Player:
		breakfast_2.toggle_eatable(true)
	AudioManager.play_sfx(plate_drop_sfx_name)
