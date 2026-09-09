extends Button
class_name MainButton

@export_subgroup("References")
@export var normal_texture_rect : TextureRect
@export var hover_texture_rect : TextureRect
@export var press_texture_rect : TextureRect
@export var text_label : Label

@export_subgroup("Button Settings")
@export var normal_text_color : Color = Color.WHITE
@export var hover_text_color : Color = Color.BLACK
@export var press_text_color : Color = Color.BLACK

@export_subgroup("Audio Settings")
@export var hover_sfx_name : String = "button_hover"
@export var press_sfx_name : String = "button_press"

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
	button_normal()

# ==================================================================================================
#                Button methods
# ==================================================================================================
func button_normal():
	normal_texture_rect.show()
	hover_texture_rect.hide()
	press_texture_rect.hide()
	text_label.modulate = normal_text_color

func button_hovered():
	normal_texture_rect.hide()
	hover_texture_rect.show()
	press_texture_rect.hide()
	text_label.modulate = hover_text_color

func button_pressed():
	normal_texture_rect.hide()
	hover_texture_rect.hide()
	press_texture_rect.show()
	text_label.modulate = press_text_color

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
