extends Node2D
class_name Sofa

@export var seat_array : Array[Seat]

func _ready() -> void:
	assert(!seat_array.is_empty(), "seat_array is missing")
	for seat:Seat in seat_array:
		seat.occupant_sat.connect(_on_occupant_sat)
		seat.occupant_stood_up.connect(_on_occupant_stood_up)

func _on_occupant_sat(node:Node):
	if node is Player: EventFlag.instance.is_sitting_on_sofa = true

func _on_occupant_stood_up(node:Node):
	if node is Player: EventFlag.instance.is_sitting_on_sofa = false
