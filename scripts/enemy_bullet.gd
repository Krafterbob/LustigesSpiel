class_name EnemyBullet extends Area2D

@export var damage : int = 1
@export var pierce : int = 1
@onready var level_borders = $"../../../LevelBorders"

var velocity = Vector2(0, 0)

func _physics_process(delta):
	
	#move bullet
	position += velocity
	
	#delete bullet if its off screen
	if (level_borders != null and position.x < level_borders.position.x - 50):
		queue_free()
		

func _on_body_entered(body):
	if body is Player:
		#damage player
		body.take_damage(damage)
		
		#knock player back
		var direction = body.position - position
		body.knockback = direction.normalized() * 10
		
		pierce -= 1
		if (pierce <= 0):
			queue_free()
