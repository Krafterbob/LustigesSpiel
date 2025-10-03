class_name Collectable extends Area2D

var velocity = Vector2(0, 0)

@export var points : int = 100
@export var heals : int = 0

@onready var animation_player = $AnimationPlayer
@onready var level_borders = $"../../../LevelBorders"

var summsumm_item_template = load("res://objects/summ_summ(item).tscn").instantiate()

func _physics_process(delta):
	#process movement
	position += velocity
	
	#prevent collectable from leaving the borders
	if (level_borders != null):
		if (position.y > 1080 + 50):
			respawn()
		if (position.y < 0 - 50):
			respawn()
		if (position.x < level_borders.position.x - 50):
			respawn()
	
	#delete collectable if its off screen
	if (level_borders != null and position.x < level_borders.position.x - 50):
		queue_free()

func _on_body_entered(body):
	#collect collectable
	if body is Player:
		collect(body)

func collect(body):
	
	if (heals > 0):
		body.take_damage(-heals)
	
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
	
func respawn():
	position.x = level_borders.position.x + camera.get_viewport_rect().size.x / camera.zoom.x
	position.y = 1080 / 2
