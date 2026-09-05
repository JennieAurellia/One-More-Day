extends Node2D
class_name Stove

@export_subgroup("References")
@export var cook_sprite : Sprite2D

@export_subgroup("Audio Settings")
@export var cooking_sound_name : String = "cooking"

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(cook_sprite, "cook_sprite is missing")
	# Initialize
	cook_sprite.hide()

# ==================================================================================================
#                Stove methods
# ==================================================================================================
func turn_on():
	cook_sprite.show()
	AudioManager.play_sound(cooking_sound_name)

func turn_off():
	cook_sprite.hide()
	AudioManager.stop_sound(cooking_sound_name)
