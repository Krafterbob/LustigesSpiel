class_name Giraffe extends Monster

func die():
	Globals.giraffeBeaten = true
	Globals.deactivateBossMode()
	super.die()
