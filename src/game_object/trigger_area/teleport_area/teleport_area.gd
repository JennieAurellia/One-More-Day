extends Area2D
class_name TeleportArea

@export var teleport_marker : Marker2D

var _player : Player

func _ready() -> void:
	assert(teleport_marker, "teleport_marker is missing")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func teleport():
	if !_player: return
	_player.global_position = teleport_marker.global_position

func _on_body_entered(body: Node2D) -> void:
	if body is Player: _player = body as Player

func _on_body_exited(body: Node2D) -> void:
	if body is Player: _player = null
