extends Node
class_name DialogueView

enum ViewPosition{
	LEFT,
	RIGHT,
	CENTER,
}

@export_subgroup("Reference")
@export var left_texture_rect : TextureRect
@export var right_texture_rect : TextureRect
@export var center_texture_rect : TextureRect
@export_subgroup("View Settings")
@export var sprite_dictionary : Dictionary[String, Texture2D]

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(left_texture_rect, "left_texture_rect is missing")
	assert(right_texture_rect, "right_texture_rect is missing")
	assert(center_texture_rect, "center_texture_rect is missing")
	# Initialize
	left_texture_rect.texture = null
	right_texture_rect.texture = null

# ==================================================================================================
#                Character view methods
# ==================================================================================================
func show_sprite(
	view_position:ViewPosition, sprite_name:String, flip_h:bool=false, flip_v:bool=false
):
	# Check is character texture registered
	if !sprite_dictionary.has(sprite_name):
		push_error("Sprite name: %s, does not have a registered texture" % sprite_name)
		return
	# Find and apply texture
	var sprite_texture : Texture2D = sprite_dictionary[sprite_name]
	var texture_rect : TextureRect
	match view_position:
		ViewPosition.LEFT: texture_rect = left_texture_rect
		ViewPosition.RIGHT: texture_rect = right_texture_rect
		ViewPosition.CENTER: texture_rect = center_texture_rect
	texture_rect.texture = sprite_texture
	texture_rect.flip_h = flip_h
	texture_rect.flip_v = flip_v

func hide_sprite(view_position:ViewPosition):
	if view_position == ViewPosition.LEFT:
		left_texture_rect.texture = null
	elif view_position == ViewPosition.RIGHT:
		right_texture_rect.texture = null
	elif view_position == ViewPosition.CENTER:
		center_texture_rect.texture = null

func hide_all_sprite():
	left_texture_rect.texture = null
	right_texture_rect.texture = null
	center_texture_rect.texture = null
