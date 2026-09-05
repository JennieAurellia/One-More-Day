extends AudioStreamPlayer
class_name MusicNode

## Key name for this music node
@export var key_name : String = ""

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready():
	# Assertion check
	assert(key_name != "", "This music node does not have a key name")
