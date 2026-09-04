extends Node2D
class_name Toilet

@export_subgroup("References")
@export var normal_sprite : Sprite2D
@export var sat_sprite : Sprite2D
@export var seat : Seat

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(normal_sprite, "normal_sprite is missing")
	assert(sat_sprite, "sat_sprite is missing")
	assert(seat, "seat is missing")
	# Connect signals
	seat.occupant_sat.connect(_on_occupant_sat)
	seat.occupant_stood_up.connect(_on_occupant_stood_up)
	# Initialize
	normal_sprite.show()
	sat_sprite.hide()

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_occupant_sat(occupant:Node):
	normal_sprite.hide()
	sat_sprite.show()

func _on_occupant_stood_up(occupant:Node):
	normal_sprite.show()
	sat_sprite.hide()
