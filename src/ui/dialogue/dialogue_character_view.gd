extends Node
class_name DialogueCharacterView

enum CharacterPosition{
	LEFT,
	RIGHT,
}

@export_subgroup("Reference")
@export var left_character_texture_rect : TextureRect
@export var right_character_texture_rect : TextureRect
@export_subgroup("Character Settings")
@export var character_dictionary : Dictionary[String, Texture2D]

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(left_character_texture_rect, "left_character_texture_rect is missing")
	assert(right_character_texture_rect, "right_character_texture_rect is missing")
	# Initialize
	left_character_texture_rect.texture = null
	right_character_texture_rect.texture = null

# ==================================================================================================
#                Character view methods
# ==================================================================================================
func show_character_sprite(character_position:CharacterPosition, character_name:String):
	# Check is character texture registered
	if !character_dictionary.has(character_name):
		push_error("Character name: %s, does not have a registered texture" % character_name)
		return
	# Find and apply texture
	var character_texture : Texture2D = character_dictionary[character_name]
	if character_position == CharacterPosition.LEFT:
		left_character_texture_rect.texture = character_texture
	elif character_position == CharacterPosition.RIGHT:
		right_character_texture_rect.texture = character_texture

func hide_character_sprite(character_position:CharacterPosition):
	if character_position == CharacterPosition.LEFT:
		left_character_texture_rect.texture = null
	elif character_position == CharacterPosition.RIGHT:
		right_character_texture_rect.texture = null
