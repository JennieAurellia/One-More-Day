extends Node2D
class_name Shower

@export_subgroup("References")
@export var interactable_component : InteractableComponent
@export var normal_sprite : Sprite2D
@export var used_sprite : Sprite2D

@export_subgroup("Shower Settings")
## Facing direction (degrees) the occupant should snap to once stand.
@export var stand_facing_degrees : float = 0.0

var _current_occupant : Node = null

## ==================================================================================================
##                Virtual methods
## ==================================================================================================
#func _ready() -> void:
	## Assertion check
	#assert(interactable_component, "interactable_component is missing")
	#assert(normal_sprite, "normal_sprite is missing")
	#assert(used_sprite, "used_sprite is missing")
	## Connect signals
	#interactable_component.hovered.connect(_on_interactable_hovered)
	#interactable_component.unhovered.connect(_on_interactable_unhovered)
	#interactable_component.interacted.connect(_on_interactable_interacted)
	#interactable_component.interacted_by_npc.connect(_on_interactable_interacted_by_npc)
	## Initialize
	#interact_color_rect.hide()
#
## ==================================================================================================
##                Seat methods
## ==================================================================================================
#func is_occupied() -> bool: return _current_occupant != null
#
### Any actor (Player or NPC) can call this directly to sit here, bypassing the interactable click.
#func sit_actor(actor:Node) -> bool:
	#if is_occupied(): return false
	#_current_occupant = actor
	#if actor.has_method("sit_at"):
		#actor.sit_at(global_position, deg_to_rad(sit_facing_degrees), self)
	#occupant_sat.emit(actor)
	#return true
#
#func stand_up() -> void:
	#if not is_occupied(): return
	#var actor := _current_occupant
	#_current_occupant = null
	#if actor.has_method("stand_up"):
		#actor.stand_up()
	#occupant_stood_up.emit(actor)
#
## ==================================================================================================
##                Signal listener methods
## ==================================================================================================
#func _on_interactable_hovered(): interact_color_rect.show()
#
#func _on_interactable_unhovered(): interact_color_rect.hide()
#
#func _on_interactable_interacted():
	#if _current_occupant == Player.instance: stand_up()
	#elif !is_occupied(): sit_actor(Player.instance)
#
#func _on_interactable_interacted_by_npc(npc:Node) -> void:
	#sit_actor(npc)
