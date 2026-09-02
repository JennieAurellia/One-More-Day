extends AnimatedSprite2D
class_name ElenaSprite

@export_subgroup("Animation Settings")
@export var idle_animation_name : String = "idle"
@export var walk_animation_name : String = "walk"
@export var interact_animation_name : String = "interact"
@export var sit_animation_name : String = "sit"

@export_subgroup("Z Index Settings")
@export var normal_z_index : int = 1
@export var sitting_z_index : int = 0

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	z_index = normal_z_index

# ==================================================================================================
#                Sprite methods
# ==================================================================================================
func do_idle():
	play(idle_animation_name)
	z_index = normal_z_index

func do_walk():
	play(walk_animation_name)
	z_index = normal_z_index

func do_interact(): play(interact_animation_name)

func do_sit():
	play(sit_animation_name)
	z_index = sitting_z_index
