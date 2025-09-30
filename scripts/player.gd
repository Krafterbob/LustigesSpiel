class_name Player extends CharacterBody2D


const SPEED = 300.0

var random = RandomNumberGenerator.new()

var directionX = 0
var directionY = 0
var facing = 1

var bullet_template = load("res://objects/bullet.tscn").instantiate()

@onready var player_sprite = $Player
@onready var running_particles = $runningParticles
@onready var level_borders = $"../LevelBorders"

var is_alive = true

func _physics_process(delta):
	velocity.x = directionX * SPEED
	velocity.y = directionY * SPEED
	
	if (velocity.x != 0 or velocity.y != 0):
		self.rotation = velocity.angle() + PI / 2;
	
	#position += velocity;
	
	move_and_slide()
	camera.position.x += (position.x - camera.position.x) / 10;
	camera.position.y += (position.y - camera.position.y) / 10;
	
	if (camera.position.y + camera.get_viewport_rect().size.y / camera.zoom.y / 2 > 1080):
		camera.position.y = 1080 - camera.get_viewport_rect().size.y / camera.zoom.y / 2;
	if (camera.position.y - camera.get_viewport_rect().size.y / camera.zoom.y / 2 < 0):
		camera.position.y = camera.get_viewport_rect().size.y / camera.zoom.y / 2;
	if (camera.position.x - camera.get_viewport_rect().size.x / camera.zoom.x / 2 < level_borders.position.x):
		camera.position.x = level_borders.position.x + camera.get_viewport_rect().size.x / camera.zoom.x / 2;
	
func _input(event):
	#if game_manager.game_state == "playing":
	#	if Input.is_action_just_pressed("jump"):
	#		pressed_jump = COYOTE_TIME
	#	if Input.is_action_just_released("jump"):
	#		if velocity.y < 0 and jumping >= maxjumping - 3:
	#			jumping = endjumping
	#		else:
	#			jumping = 0
	#	
	#	if Input.is_action_just_pressed("interact"):
	#		pressed_interact = COYOTE_TIME

	if event.is_action_pressed("left_click"):
			
		var direction = Vector2((event.position.x / camera.zoom.x + camera.position.x - camera.get_viewport_rect().size.x / camera.zoom.x / 2) - position.x, 
								 (event.position.y / camera.zoom.y + camera.position.y - camera.get_viewport_rect().size.y / camera.zoom.y / 2) - position.y);
		
		var bullet = bullet_template.duplicate()
		bullet.position = position + direction.normalized() * 50
		bullet.velocity = direction.normalized() * 750
		
		get_parent().add_child(bullet)
		

	directionX = Input.get_axis("move_left", "move_right")
	if directionX != 0:
		facing = directionX
	directionY = Input.get_axis("move_up", "move_down")
	if directionY != 0:
		facing = directionY
