extends Button
class_name BasicButon

@export var normal_color: Color = Color.WHITE
@export var hover_color: Color = Color(0.8, 0.8, 0.8)
@export var pressed_color: Color = Color(0.4, 0.4, 0.4)
@export var tween_time: float = 0.15

var _tween: Tween

func _ready() -> void:
	modulate = normal_color
	mouse_entered.connect(_tween_to.bind(hover_color))
	mouse_exited.connect(_tween_to.bind(normal_color))
	button_down.connect(_tween_to.bind(pressed_color))
	button_up.connect(_on_button_up)

func _on_button_up() -> void:
	# Return to hover color if the mouse is still over the button
	_tween_to(hover_color if is_hovered() else normal_color)

func _tween_to(target: Color) -> void:
	if _tween and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "modulate", target, tween_time)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
