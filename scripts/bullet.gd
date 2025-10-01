class_name Bullet extends CharacterBody2D

@export var friendly : bool = false

var lifetime = 200;
var pierce = 3.0
var pierceMax = 3.0

func _physics_process(delta):
	move_and_slide()
	lifetime -= 1
	if (lifetime <= 0):
		queue_free()
