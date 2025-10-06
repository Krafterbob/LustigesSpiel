extends Node

@onready var player : Player = $"../../../../Player"
var monster

var speed = 2
var random = RandomNumberGenerator.new()
var counter = 0

func _init():
	monster = get_parent()

func _process(delta):
	
	if (monster == null):
		monster = get_parent()
		return;
	
	if (player != null):
		if (counter == 0):
			var direction = player.position - monster.position
			if (direction.length() < camera.get_viewport_rect().size.x / camera.zoom.x / 2):
				direction *= -1;
				direction = direction.from_angle(direction.angle() + 2 * PI / 360  * (random.randi_range(0, 120) - 60));
				monster.velocity = direction.normalized() * speed
			else:
				monster.velocity = Vector2.ZERO
		counter += 1
		if (counter >= 100):
			counter = 0
