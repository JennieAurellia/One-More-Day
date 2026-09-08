extends TextureButton
class_name ResponseButton

@export_subgroup("References")
@export var text_label : Label

@export_subgroup("Button Settings")
@export var normal_text_color : Color = Color.WHITE
@export var hover_text_color : Color = Color.BLACK
@export var press_text_color : Color = Color.BLACK

var text : String:
	set(value):
		text_label.text = value

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
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
	text_label.modulate = normal_text_color

func button_hovered():
	text_label.modulate = hover_text_color

func button_pressed():
	text_label.modulate = press_text_color

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_mouse_entered() -> void: button_hovered()

func _on_mouse_exited() -> void: button_normal()

func _on_button_down() -> void: button_pressed()

func _on_button_up() -> void:
	if is_hovered(): button_hovered()
	else: button_normal()
