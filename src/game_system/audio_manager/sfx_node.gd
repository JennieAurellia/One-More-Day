extends AudioStreamPlayer2D
class_name SFXNode

## Key name for this music node
@export var key_name : String = ""
var sfx_duplicate_list : Array[AudioStreamPlayer2D] = []

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready():
	# Assertion check
	assert(key_name != "", "This SFX node does not have a key name")

# ================================================================================
#           Public methods
# ================================================================================
## Returns a AudioStreamPlayer2D duplicate using SFX node paramaters
func create_sfx_duplicate()->AudioStreamPlayer2D:
	var sfx_duplicate_instance : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	sfx_duplicate_instance.stream = stream
	sfx_duplicate_instance.volume_db = volume_db
	sfx_duplicate_instance.pitch_scale = pitch_scale
	sfx_duplicate_instance.autoplay = true
	sfx_duplicate_instance.max_distance = max_distance
	sfx_duplicate_instance.attenuation = attenuation
	sfx_duplicate_instance.panning_strength = panning_strength
	sfx_duplicate_instance.bus = bus
	sfx_duplicate_instance.finished.connect(erase_sfx_duplicate.bind(sfx_duplicate_instance))
	return sfx_duplicate_instance

## Erase a specific AudioStreamPlayer2D duplicate in the SFX duplicate list
func erase_sfx_duplicate(sfx_duplicate:AudioStreamPlayer2D):
	sfx_duplicate_list.erase(sfx_duplicate)
	sfx_duplicate.queue_free()

## Returns true if max polyphony reached (In other words, if SFX duplicates reaches limit)
func is_max_polyphony_reached()->bool:
	return sfx_duplicate_list.size() >= max_polyphony
