class_name Player extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -29.0 - 9.8
const COYOTE_TIME = 5
const INTERACTION_RANGE = 30

var random = RandomNumberGenerator.new()

var jumping = 0
var maxjumping = 10
var endjumping = 5
var directionX = 0
var directionY = 0
var facing = 1
var interacting = false

var pressed_jump = 0
var was_on_floor = 0
var pressed_interact = 0

@onready var player_sprite = $Player
@onready var interacRayR = $interactionRayRight
@onready var interacRayL = $interactionRayLeft
@onready var running_particles = $runningParticles

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_alive = true
	
func _physics_process(delta):
	#if (directionX == 1):
	#	player_sprite.flip_h = false
	#if (directionX == -1):
	#	player_sprite.flip_h = true
	#if (directionY == -1):
	#	player_sprite.flip_v = false
	#if (directionY == 1):
	#	player_sprite.flip_v = true
	velocity.x = directionX * SPEED
	velocity.y = directionY * SPEED
	
	if (velocity.x != 0 or velocity.y != 0):
		self.rotation = velocity.angle() + PI / 2;
	
	#position += velocity;
	
	move_and_slide()
	camera.position.x += (position.x - camera.position.x) / 10;
	camera.position.y += (position.y - camera.position.y) / 10;
	
	if (camera.position.y + get_viewport_rect().size.y > 1080):
		camera.position.y = 1080 - get_viewport_rect().size.y;
	
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

	directionX = Input.get_axis("move_left", "move_right")
	if directionX != 0:
		facing = directionX
	directionY = Input.get_axis("move_up", "move_down")
	if directionY != 0:
		facing = directionY
