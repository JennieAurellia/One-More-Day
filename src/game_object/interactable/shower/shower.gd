extends Node2D
class_name Shower

@export_subgroup("References")
@export var normal_sprite : Sprite2D
@export var locked_sprite : Sprite2D
@export var lock_collision : CollisionShape2D

@export_subgroup("Audio Settings")
@export var open_sfx_name : String = "shower_open"
@export var close_sfx_name : String = "shower_close"
@export var showering_sound_name : String = "showering"

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(normal_sprite, "normal_sprite is missing")
	assert(locked_sprite, "locked_sprite is missing")
	assert(lock_collision, "lock_collision is missing")
	# Initialize
	normal_sprite.show()
	locked_sprite.hide()
	lock_collision.disabled = true

# ==================================================================================================
#                Stove methods
# ==================================================================================================
func lock():
	normal_sprite.hide()
	locked_sprite.show()
	lock_collision.disabled = false
	AudioManager.play_sfx(open_sfx_name)
	AudioManager.play_sound(showering_sound_name)

func unlock():
	normal_sprite.show()
	locked_sprite.hide()
	lock_collision.disabled = true
	AudioManager.play_sfx(close_sfx_name)
	AudioManager.stop_sound(showering_sound_name)
