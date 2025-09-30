extends Node

@onready var player : Player = $"../../../../Player"
var monster : Monster

var speed = 3

func _init():
	monster = get_parent()

func _process(delta):
	
	if (monster == null):
		monster = get_parent()
		return;
	
	if (player != null):
		var direction = player.position - monster.position
		monster.velocity = direction.normalized() * speed
