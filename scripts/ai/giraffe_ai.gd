extends Node

@onready var player : Player = $"../../../../Player"
var monster : Monster
var state = 0
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
	stateTimer += 1
	if (stateTimer == 200):
		state = 1
		
	if (stateTimer == 600):
		state = 0
		stateTimer = 0
	
	#code for state 0
	if (state == 0):
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
		
	#move giraffe
	monster.position += (target_pos - monster.position) / 50
