class_name Monster extends Area2D

@export var points : int
@export var health : float
@export var damagable : bool = true
@export var isBossEnemy : bool = false
@export var knockbackMultiplier : float = 1.0
@export var pierces : int = 1.0

var velocity = Vector2(0, 0)
var knockback = Vector2(0, 0)

@onready var animation_player = $AnimationPlayer
@onready var level_borders = $"../../../LevelBorders"

var summsumm_item_template = load("res://objects/summ_summ(item).tscn").instantiate()

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
		body.pierce -= pierces
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
	#split points up into packets with the value 5
	var random = RandomNumberGenerator.new()
	for i in range(0, points / 5, 1):
		var summsumm_item = summsumm_item_template.duplicate()
		summsumm_item.position = position + Vector2(random.randi_range(0, 200) - 100, random.randi_range(0, 200) - 100)
		summsumm_item.points = 5
		get_parent().get_parent().get_parent().add_child(summsumm_item)
		
	#spawn the left over points
	if (points % 5 != 0):
		var summsumm_item = summsumm_item_template.duplicate()
		summsumm_item.position = position + Vector2(random.randi_range(0, 200) - 100, random.randi_range(0, 200) - 100)
		summsumm_item.points = points % 5
		get_parent().get_parent().get_parent().add_child(summsumm_item)
	
	queue_free()
