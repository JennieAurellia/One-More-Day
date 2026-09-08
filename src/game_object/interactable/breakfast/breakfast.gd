extends Node2D
class_name Breakfast

@export_subgroup("References")
@export var interactable_component : InteractableComponent
@export var interact_hover_ui : Control

@export_subgroup("Audio Settings")
@export var eat_sfx_name : String = "eat"

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(interactable_component, "interactable_component is missing")
	assert(interact_hover_ui, "interact_hover_ui is missing")
	# Connect signals
	interactable_component.hovered.connect(_on_interactable_hovered)
	interactable_component.unhovered.connect(_on_interactable_unhovered)
	interactable_component.interacted.connect(_on_interactable_interacted)
	# Initialize
	interact_hover_ui.hide()

# ==================================================================================================
#                Food methods
# ==================================================================================================
func eat():
	AudioManager.play_sfx(eat_sfx_name)
	queue_free()

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_interactable_hovered(): interact_hover_ui.show()

func _on_interactable_unhovered(): interact_hover_ui.hide()

func _on_interactable_interacted(): eat()
