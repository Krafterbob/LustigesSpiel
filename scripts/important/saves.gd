class_name Saves extends Resource

const SAVE_GAME_PATH := "res://saves/save1.tres"

@export var highscore : int

func write_save() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)
	
static func load_save() -> Resource:
	if ResourceLoader.exists(SAVE_GAME_PATH):
		return load(SAVE_GAME_PATH)
	return null
