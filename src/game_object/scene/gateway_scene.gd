extends Node2D

const ENDING_SCENE_PATH : String = "res://src/scene/ending_scene.tscn"
const MAIN_MENU_SCENE_PATH : String = "res://src/scene/main_menu_scene.tscn"

func _ready() -> void:
	SaveManager.load_game()
	if SaveManager.get_value("has_ended_game", false): call_deferred("change_to_ending")
	else: call_deferred("change_to_main_menu")

func change_to_ending(): get_tree().change_scene_to_file(ENDING_SCENE_PATH)

func change_to_main_menu(): get_tree().change_scene_to_file(MAIN_MENU_SCENE_PATH)
