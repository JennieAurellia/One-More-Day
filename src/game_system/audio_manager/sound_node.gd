extends AudioStreamPlayer2D
class_name SoundNode

@export var key_name : String = ""

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready():
	# Assertion check
	assert(key_name != "", "This sound node does not have a name")
