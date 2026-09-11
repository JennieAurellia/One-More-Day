extends Node2D

const MAIN_MENU_SCENE_PATH : String = "res://src/scene/main_menu_scene.tscn"

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	SaveManager.set_value("has_ended_game", false)
	SaveManager.save_game()
	get_tree().change_scene_to_file(MAIN_MENU_SCENE_PATH)
