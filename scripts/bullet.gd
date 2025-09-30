class_name Bullet extends CharacterBody2D

var lifetime = 200;
var pierce = 500

func _physics_process(delta):
	move_and_slide()
	lifetime -= 1
	if (lifetime <= 0):
		queue_free()
