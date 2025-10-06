class_name Lasso extends EnemyBullet

@onready var player : Player = $"../../Player"
var monster : Monster
var speed = 20;

func _physics_process(delta):
	
	#avoid any null-pointer exception
	if (monster == null):
		monster = get_parent()
		return;
	if (player == null):
		return
	
	#move bullet
	velocity = (player.position - position).normalized() * 20;
	position += velocity
	
	#delete bullet if its off screen
	if ((level_borders != null and position.x < level_borders.position.x - 50)
		or position.y < 0 or position.y > 1080):
		queue_free()
		
