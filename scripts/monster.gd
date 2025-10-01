class_name Monster extends Area2D

@export var points : float
@export var health : float
@export var damagable : bool = true
@export var isBossEnemy : bool = false
@export var knockbackMultiplier : float = 1.0

var velocity = Vector2(0, 0)
var knockback = Vector2(0, 0)

@onready var animation_player = $AnimationPlayer
@onready var level_borders = $"../../../LevelBorders"

func _physics_process(delta):
	#process knockback
	knockback *= 0.9
	position += velocity + knockback
	
	#delete monster if its off screen
	if (level_borders != null and position.x < level_borders.position.x - 50):
		queue_free()
		
	#delete monster if a boss is alive
	if (Globals.bossMode and !isBossEnemy):
		queue_free()

func _on_body_entered(body):
	if body is Bullet:
		#process bullet
		body.pierce -= 1
		body.scale = Vector2(body.pierce / body.pierceMax, body.pierce / body.pierceMax)
		body.velocity *= 0.5
		if (body.pierce <= 0 or !damagable):
			body.queue_free()
		
		#take damage and knockback
		take_damage(1)
		if (damagable):
			var direction = position - body.position
			knockback = direction.normalized() * 10 * knockbackMultiplier
	if body is Player:
		#damage player
		body.take_damage(1)
		
		#knock player back
		var direction = body.position - position
		body.knockback = direction.normalized() * 10

func take_damage(damage : int):
	if (damagable):
		health -= damage
		animation_player.stop()
		animation_player.play("damage")
		if (health <= 0):
			die()
	else:
		animation_player.stop()
		animation_player.play("no_damage")

func die():
	Globals.points += points
	queue_free()
