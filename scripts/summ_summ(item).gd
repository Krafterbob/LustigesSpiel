extends Sprite2D

var velocity = Vector2(0, 0)
@onready var level_borders = $"../LevelBorders"
var speed = 1

var points : int = 0

func _physics_process(delta):
	#process movement
	velocity = Vector2(camera.position.x + camera.get_viewport_rect().size.x / camera.zoom.x / 2.0 - 200,
					   camera.position.y - camera.get_viewport_rect().size.y / camera.zoom.y / 2.0 + 50) - position
	velocity = velocity.normalized() * speed
	speed *= 1.05
	position += velocity
	
	if (position.x > camera.position.x + camera.get_viewport_rect().size.x / camera.zoom.x / 2.0 - 200 and 
		position.y < camera.position.y - camera.get_viewport_rect().size.y / camera.zoom.y / 2.0 + 50):
			Globals.points += points
			queue_free()
