extends Node2D
class_name DiningTable

@export_subgroup("References")
@export var breakfast_1 : Breakfast
@export var breakfast_2 : Breakfast

@export_subgroup("Audio Settings")
@export var plate_drop_sfx_name : String = "plate_drop"

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(breakfast_1, "breakfast_1 is missing")
	assert(breakfast_2, "breakfast_2 is missing")
	# Initialize
	breakfast_1.hide()
	breakfast_2.hide()

# ==================================================================================================
#                Stove methods
# ==================================================================================================
func place_breakfast():
	breakfast_1.show()
	breakfast_2.show()
	AudioManager.play_sfx(plate_drop_sfx_name)
