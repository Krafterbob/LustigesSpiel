extends Node

var counter = 0
var random = RandomNumberGenerator.new()

var wal_template = load("res://objects/wal.tscn").instantiate()
var spawnInteval = 50

@onready var level_borders = $"../LevelBorders"

func _physics_process(delta):
	counter += 1
	if (counter >= spawnInteval):
		counter = 0;
		
		#for i in range(0, 3, 1):
		var position = Vector2((level_borders.position.x / camera.zoom.x + camera.position.x + camera.get_viewport_rect().size.x / camera.zoom.x / 2), 
							(random.randi_range(0, 1080)))
		
		var wal = wal_template.duplicate()
		wal.position = position
		
		get_parent().add_child(wal)
