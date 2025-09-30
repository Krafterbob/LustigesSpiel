class_name Giraffe extends Monster

func _physics_process(delta):
	print("alive " + str(position))

func die():
	Globals.giraffeBeaten = true
	Globals.deactivateBossMode()
	print("IM DEAD")
	super.die()
