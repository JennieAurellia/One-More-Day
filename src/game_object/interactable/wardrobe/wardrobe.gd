extends Node2D
class_name Wardrobe

@export_subgroup("References")
@export var normal_sprite : Sprite2D
@export var opened_sprite : Sprite2D

@export_subgroup("Audio Settings")
@export var open_sfx_name : String = "wardrobe_open"
@export var close_sfx_name : String = "wardrobe_close"

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(normal_sprite, "normal_sprite is missing")
	assert(opened_sprite, "opened_sprite is missing")
	# Initialize
	normal_sprite.show()
	opened_sprite.hide()

# ==================================================================================================
#                Stove methods
# ==================================================================================================
func open():
	normal_sprite.hide()
	opened_sprite.show()
	AudioManager.play_sfx(open_sfx_name)

func close():
	normal_sprite.show()
	opened_sprite.hide()
	AudioManager.play_sfx(close_sfx_name)
