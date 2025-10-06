class_name GlobalsManager extends Node

var saves : Saves

var levelStartPos : int = 0

var difficultiy = 3
var defaultDifficultiy = 3

var points : int
var bossMode = false

var giraffeBeaten = false

func _ready() -> void:
	create_or_load_save()
	
func create_or_load_save():
	saves = Saves.load_save() as Saves

func activateBossMode():
	bossMode = true
	
func deactivateBossMode():
	bossMode = false

func addPoints(points):
	self.points += points
	if (self.points > saves.highscore):
		saves.highscore = self.points
		saves.write_save()
