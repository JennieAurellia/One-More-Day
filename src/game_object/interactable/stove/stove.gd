extends Node2D
class_name Stove

@export_subgroup("References")
@export var cook_sprite : Sprite2D

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(cook_sprite, "cook_sprite is missing")
	# Initialize
	turn_off()

# ==================================================================================================
#                Stove methods
# ==================================================================================================
func turn_on():
	cook_sprite.show()

func turn_off():
	cook_sprite.hide()
