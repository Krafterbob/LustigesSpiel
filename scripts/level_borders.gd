extends StaticBody2D

var speed = 2;

func _physics_process(delta):
	if (!Globals.bossMode):
		position.x += speed;
