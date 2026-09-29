extends Button
class_name MainButton

# White with zero alpha, so hiding only fades alpha and doesn't darken the texture
const TEX_SHOWN : Color = Color.WHITE
const TEX_HIDDEN : Color = Color(1.0, 1.0, 1.0, 0.0)

@export_subgroup("References")
@export var normal_texture_rect : TextureRect
@export var hover_texture_rect : TextureRect
@export var press_texture_rect : TextureRect
@export var text_label : Label

@export_subgroup("Button Settings")
@export var normal_text_color : Color = Color.WHITE
@export var hover_text_color : Color = Color.BLACK
@export var press_text_color : Color = Color.BLACK

@export_subgroup("Tween Settings")
@export var color_tween_duration : float = 0.15
@export var tween_trans : Tween.TransitionType = Tween.TRANS_SINE
@export var tween_ease : Tween.EaseType = Tween.EASE_OUT

@export_subgroup("Audio Settings")
@export var hover_sfx_name : String = "button_hover"
@export var press_sfx_name : String = "button_press"

var _tween : Tween

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(normal_texture_rect, "normal_texture_rect is missing")
	assert(hover_texture_rect, "hover_texture_rect is missing")
	assert(press_texture_rect, "press_texture_rect is missing")
	assert(text_label, "text_label is missing")
	# Connect signals
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	# Initialize
	normal_texture_rect.show()
	hover_texture_rect.show()
	press_texture_rect.show()
	button_normal(true)

# ==================================================================================================
#                Button methods
# ==================================================================================================
func button_normal(instant : bool = false):
	_tween_button(TEX_SHOWN, TEX_HIDDEN, TEX_HIDDEN, normal_text_color, instant)

func button_hovered():
	_tween_button(TEX_HIDDEN, TEX_SHOWN, TEX_HIDDEN, hover_text_color)

func button_pressed():
	_tween_button(TEX_HIDDEN, TEX_HIDDEN, TEX_SHOWN, press_text_color)

# ==================================================================================================
#                Tween methods
# ==================================================================================================
func _tween_button(
	normal_mod:Color, hover_mod:Color, press_mod:Color, text_color:Color, instant:bool=false
) -> void:
	# Check for current tween
	if _tween and _tween.is_valid(): _tween.kill()
	# Check is it instant
	if instant or color_tween_duration <= 0.0:
		normal_texture_rect.modulate = normal_mod
		hover_texture_rect.modulate = hover_mod
		press_texture_rect.modulate = press_mod
		text_label.modulate = text_color
		return
	# Do tween
	_tween = create_tween().set_parallel(true)
	_tween.set_trans(tween_trans).set_ease(tween_ease)
	_tween.tween_property(normal_texture_rect, "modulate", normal_mod, color_tween_duration)
	_tween.tween_property(hover_texture_rect, "modulate", hover_mod, color_tween_duration)
	_tween.tween_property(press_texture_rect, "modulate", press_mod, color_tween_duration)
	_tween.tween_property(text_label, "modulate", text_color, color_tween_duration)

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_mouse_entered() -> void:
	button_hovered()
	AudioManager.play_sfx(hover_sfx_name)

func _on_mouse_exited() -> void: button_normal()

func _on_button_down() -> void:
	button_pressed()
	AudioManager.play_sfx(press_sfx_name)

func _on_button_up() -> void:
	if is_hovered(): button_hovered()
	else: button_normal()
