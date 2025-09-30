class_name Monster extends Area2D

var health = 3
var velocity = Vector2(0, 0)
var knockback = Vector2(0, 0)

@onready var animation_player = $AnimationPlayer

func _physics_process(delta):
	knockback *= 0.9
	position += velocity + knockback

func _on_body_entered(body):
	if body is Bullet:
		
		#process smiley
		body.pierce -= 1
		if (body.pierce <= 0):
			body.queue_free()
		
		#take damage
		take_damage(1)
		
		#take knockback
		var direction = position - body.position
		knockback = direction.normalized() * 10
			

func take_damage(damage : int):
	health -= damage
	animation_player.play("damage")
	if (health <= 0):
		die()

func die():
	queue_free()
