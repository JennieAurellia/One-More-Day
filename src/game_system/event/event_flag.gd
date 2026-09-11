extends Node
class_name EventFlag

static var instance : EventFlag

signal exited_bedroom
signal peeked_present
signal peeked_doll
signal peeked_inside_phone
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
## Has player see Elena's hidden present
static var has_peek_present : bool = false:
	set(value):
		has_peek_present = value
		if instance and value: instance.peeked_present.emit()
## Has player see Elena's doll
static var has_peek_doll : bool = false:
	set(value):
		has_peek_doll = value
		if instance and value: instance.peeked_doll.emit()
## Has player see dialogue inside Elena's phone
static var has_peek_inside_phone : bool = false:
	set(value):
		has_peek_inside_phone = value
		if instance and value: instance.peeked_inside_phone.emit()
## Has read Elena's diary
static var has_read_diary : bool = false:
	set(value):
		has_read_diary = value
		if instance and value: instance.read_diary.emit()

# ========== Prive interaction ==========
var is_present_proved : bool = false
var is_call_proved : bool = false
var is_diary_proved : bool = false
var is_doll_proved : bool = false
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
	has_peek_present = false
	has_peek_doll = false
	has_peek_inside_phone = false
	has_read_diary = false
