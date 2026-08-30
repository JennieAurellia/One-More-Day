extends AnimatedSprite2D
class_name PlayerSprite

@export_subgroup("Animation Settings")
@export var idle_animation_name : String = "idle"
@export var walk_animation_name : String = "walk"
@export var interact_animation_name : String = "interact"
@export var sit_animation_name : String = "sit"

# ==================================================================================================
#                Sprite methods
# ==================================================================================================
func do_idle(): play(idle_animation_name)

func do_walk(): play(walk_animation_name)

func do_interact(): play(interact_animation_name)

func do_sit(): play(sit_animation_name)
