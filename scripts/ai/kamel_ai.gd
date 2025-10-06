extends Node

@onready var player : Player = $"../../../../Player"
var monster : Monster
var state = 0

var hopDistance = 200
var target_pos = Vector2(0 ,0)

var feuerball_template = load("res://objects/projectiles/feuerball.tscn").instantiate()
@onready var animation_player = $"../AIAnimations"

func _init():
	monster = get_parent()
	if (monster != null):
		target_pos = monster.position

func _process(delta):

	#avoid any null-pointer exception
	if (monster == null):
		monster = get_parent()
		if (monster != null):
			target_pos = monster.position
		return;
	if (player == null):
		return
	
	#code for state 0
	if (state == 0):
		if (player.position.x < monster.position.x - 2 * hopDistance
			and animation_player.current_animation != "walk"):
			target_pos = monster.position - Vector2(hopDistance, 0)
			animation_player.play("walk")
		elif (player.position.x >= monster.position.x - hopDistance):
			state = 1
		
	if (state == 1):
		if (animation_player.current_animation != "rotateLasso"):
			animation_player.play("roateLasso")
	
	#move giraffe
	monster.position += (target_pos - monster.position) / 60
