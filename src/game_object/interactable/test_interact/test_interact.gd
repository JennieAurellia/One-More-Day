extends Node2D
class_name TestInteract

@export_subgroup("References")
@export var interactable_component : InteractableComponent
@export var sprite : Sprite2D

@export_subgroup("Interact Settings")
@export var normal_color : Color = Color.WHITE
@export var hover_color : Color = Color.YELLOW
@export var interact_message : String = "Object interacted"

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(interactable_component, "interactable_component is missing")
	assert(sprite, "sprite is missing")
	# Connect signals
	interactable_component.interactable_hovered.connect(_on_interactable_hovered)
	interactable_component.interactable_unhovered.connect(_on_interactable_unhovered)
	interactable_component.interactable_interacted.connect(_on_interactable_interacted)

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_interactable_hovered(): sprite.modulate = hover_color

func _on_interactable_unhovered(): sprite.modulate = normal_color

func _on_interactable_interacted(): print(interact_message)
