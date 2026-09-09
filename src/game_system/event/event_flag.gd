extends Node
class_name EventFlag

static var instance : EventFlag

signal exited_bedroom

# ========== Cook phase ==========
## Has the player exited the bedroom
var has_exited_bedroom : bool = false:
	set(value):
		has_exited_bedroom = value
		exited_bedroom.emit()
## Is Elena comming to bedroom because player has not exited the bedroom
var is_comming_to_bedroom : bool = false
## Has player and Elena talked before having breakfast
var has_talked_before_breakfast : bool = false

# ========== Eat phase ==========
## Is the breakfast can be eaten
var is_breakfast_eatable : bool = false
## Has the player ate breakfast
var has_ate_breakfast : bool = false
## Has player and Elena talked after having breakfast
var has_talked_after_breakfast : bool = false

# ========== Chill phase ==========
## is player sitting on sofa
var is_sitting_on_sofa : bool = false
## Has player and Elena talked while sitting on sofa
var has_talked_while_chilling : bool = false

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _enter_tree() -> void: instance = self

func _exit_tree() -> void: instance = null
