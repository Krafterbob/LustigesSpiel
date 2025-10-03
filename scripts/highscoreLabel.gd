extends Label

func _process(delta):
		text = str("Highscore: " + str(Globals.saves.highscore))
