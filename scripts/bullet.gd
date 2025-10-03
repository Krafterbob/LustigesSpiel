class_name Bullet extends CharacterBody2D

@export var friendly : bool = false
@export var damae : int = 1

@onready var sprite = $Smiley

var lifetime = 200;
var pierce = 3.0
var pierceMax = 3.0
var supercharged = 0

func _physics_process(delta):
	
	#change supercharge
	sprite.material.set("shader_parameter/active", supercharged > 0);
	
	#move
	move_and_slide()
	lifetime -= 1
	if (lifetime <= 0):
		queue_free()
