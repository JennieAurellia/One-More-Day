extends Node
class_name EventFlag

static var instance : EventFlag

signal exited_bedroom
signal peaked_inside_phone
signal read_diary

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

# ========== Ready phase ==========
## Is Elena doing a phone call with her friend
var is_elena_phone_calling : bool = false

# ========== Item interaction ==========
## Has player found Elena's hidden present
var has_found_present : bool = false
## Has player found Elena's diary
var has_found_diary : bool = false
## Has player see dialogue inside Elena's phone
static var has_peak_inside_phone : bool = false:
	set(value):
		has_peak_inside_phone = value
		if instance and value: instance.peaked_inside_phone.emit()
## Has read Elena's diary
var has_read_diary : bool = false:
	set(value):
		has_read_diary = value
		read_diary.emit()

# ========== Prive interaction ==========
var is_present_proved : bool = false
var is_call_proved : bool = false
var is_diary_proved : bool = false
var is_prove_successful : bool = false

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _enter_tree() -> void: instance = self

func _exit_tree() -> void: instance = null

# ==================================================================================================
#                Main methods
# ==================================================================================================
static func reset_event():
	has_peak_inside_phone = false
