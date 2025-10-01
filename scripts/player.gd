class_name Player extends CharacterBody2D


const SPEED = 300.0

var health = 5
var maxHealth = 5

var random = RandomNumberGenerator.new()

var directionX = 0
var directionY = 0
var facing = 1
var knockback = Vector2(0, 0)

var bullet_template = load("res://objects/projectiles/bullet.tscn").instantiate()

@onready var player_sprite = $Player
@onready var running_particles = $runningParticles
@onready var level_borders = $"../LevelBorders"
@onready var animation_player = $AnimationPlayer

var is_alive = true

func _physics_process(delta):
	#process knockback
	knockback *= 0.9
	position += knockback
	
	#process movement
	velocity.x = directionX * SPEED
	velocity.y = directionY * SPEED
	
	#smooth player rotation towards movement direction
	var target_angle
	if (velocity.x != 0 or velocity.y != 0):
		target_angle = velocity.angle()
		var rot = self.rotation + PI
		var difference = target_angle - rot;
		if (difference > PI):
			difference = -2 * PI - target_angle + rot;
		if (difference < -PI):
			difference = 2 * PI - rot + target_angle;
		self.rotation += difference / 10
	
	#move the player
	move_and_slide()
	
	#move the camera
	camera.position.x += (position.x - camera.position.x) / 10;
	camera.position.y += (position.y - camera.position.y) / 10;
	if (camera.position.y + camera.get_viewport_rect().size.y / camera.zoom.y / 2 > 1080):
		camera.position.y = 1080 - camera.get_viewport_rect().size.y / camera.zoom.y / 2;
	if (camera.position.y - camera.get_viewport_rect().size.y / camera.zoom.y / 2 < 0):
		camera.position.y = camera.get_viewport_rect().size.y / camera.zoom.y / 2;
	if (camera.position.x - camera.get_viewport_rect().size.x / camera.zoom.x / 2 < level_borders.position.x):
		camera.position.x = level_borders.position.x + camera.get_viewport_rect().size.x / camera.zoom.x / 2;
		
	#move the border
	if (!Globals.bossMode and position.x - camera.get_viewport_rect().size.x / camera.zoom.x / 2 - 50 > level_borders.position.x):
		level_borders.position.x = position.x - camera.get_viewport_rect().size.x / camera.zoom.x / 2 - 50;
	
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

func take_damage(damage : int):
	if (animation_player.is_playing()):
		return
		
	health -= damage
	
	var c = float(health) / float(maxHealth) * 1;
	player_sprite.self_modulate = Color(c, c, c, 1)
	scale = Vector2(c, c)
	animation_player.play("damage")
	
	if (health <= 0):
		die()
	
func die():
	queue_free()
