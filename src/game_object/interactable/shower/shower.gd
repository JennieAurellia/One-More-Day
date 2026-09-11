extends Node2D
class_name Shower

@export_subgroup("References")
@export var normal_sprite : Sprite2D
@export var locked_sprite : Sprite2D
@export var lock_collision : CollisionShape2D
@export var teleport_area : TeleportArea
@export var bubbles : TextureRect
@export var ui_block : Control

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
	assert(teleport_area, "teleport_area is missing")
	assert(bubbles, "bubbles is missing")
	assert(ui_block, "ui_block is missing")
	# Initialize
	normal_sprite.show()
	locked_sprite.hide()
	lock_collision.disabled = true
	bubbles.hide()
	ui_block.hide()

# ==================================================================================================
#                Stove methods
# ==================================================================================================
func lock():
	normal_sprite.hide()
	locked_sprite.show()
	lock_collision.disabled = false
	teleport_area.teleport()
	bubbles.show()
	ui_block.show()
	AudioManager.play_sfx(open_sfx_name)
	AudioManager.play_sound(showering_sound_name)

func unlock():
	normal_sprite.show()
	locked_sprite.hide()
	lock_collision.disabled = true
	bubbles.hide()
	ui_block.hide()
	AudioManager.play_sfx(close_sfx_name)
	AudioManager.stop_sound(showering_sound_name)
