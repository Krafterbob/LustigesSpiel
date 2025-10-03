extends Node

@onready var player : Player = $"../../../../Player"
var monster : Monster
var state = -1
var stateTimer = 0

var speed = 3
var target_pos = Vector2(0 ,0)

var feuerball_template = load("res://objects/projectiles/feuerball.tscn").instantiate()
@onready var animation_player = $"../AIAnimations"
@onready var feuerball_spawner = $"../FeuerballSpawner"

func _init():
	monster = get_parent()

func _process(delta):

	#avoid any null-pointer exception
	if (monster == null):
		monster = get_parent()
		return;
	if (player == null):
		return
	
	#change states
	if (animation_player.current_animation != "spawn"):
		stateTimer += 1
	else:
		monster.position.x = player.position.x + camera.get_viewport_rect().size.x / camera.zoom.x * 0.35
		monster.position.y = player.position.y
		target_pos = monster.position
	if (stateTimer == 1):
		state = 0
	
	if (stateTimer == 200):
		state = 1
		
	if (stateTimer == 800):
		state = 2
		
	if (stateTimer == 1000):
		state = 3
				
	if (stateTimer == 1400):
		animation_player.stop()
		state = 4
		
	if (stateTimer == 1520):
		state = 0
		stateTimer = 0
	
	#code for state 0
	if (state == 0 or state == 2):
		if (player.position.x > monster.position.x):
			if (stateTimer == 1 or stateTimer == 800):
				animation_player.play("teleport")
			if (stateTimer == 61 or stateTimer == 860):
				monster.position.x = player.position.x + camera.get_viewport_rect().size.x / camera.zoom.x / 2
				target_pos = monster.position
		else:
			target_pos.x = player.position.x + camera.get_viewport_rect().size.x / camera.zoom.x / 2
			target_pos.y = player.position.y
		
	if (state == 1):
		if (stateTimer % 100 == 0):
			animation_player.play("shoot")
		if (animation_player.current_animation != "shoot" and stateTimer % 100 != 0):
			var feuerball = feuerball_template.duplicate()
			feuerball.position = monster.position + feuerball_spawner.position
			feuerball.velocity = Vector2(-5, 0)
			get_parent().get_parent().get_parent().get_parent().add_child(feuerball)
			stateTimer += 100
			stateTimer -= stateTimer % 100 + 1
	
	if (state == 3):
		if (stateTimer == 1000):
			animation_player.play("dash")
		if (stateTimer == 1200):
			target_pos.x = monster.position.x - camera.get_viewport_rect().size.x / camera.zoom.x * 0.75
			
	if (state == 4):
		if (stateTimer == 1400):
			animation_player.play("teleport")
		if (stateTimer == 1460):
			monster.position.x = player.position.x + camera.get_viewport_rect().size.x / camera.zoom.x / 2
			target_pos = monster.position
		
	#move giraffe
	monster.position += (target_pos - monster.position) / 50
