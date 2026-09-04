extends Node2D
class_name Wardrobe

@export_subgroup("References")
@export var normal_sprite : Sprite2D
@export var opened_sprite : Sprite2D

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(normal_sprite, "normal_sprite is missing")
	assert(opened_sprite, "opened_sprite is missing")
	# Initialize
	close()

# ==================================================================================================
#                Stove methods
# ==================================================================================================
func open():
	normal_sprite.hide()
	opened_sprite.show()

func close():
	normal_sprite.show()
	opened_sprite.hide()
