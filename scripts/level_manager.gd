extends Node

#monster spawn variables
var spawnTimer = 0
var random = RandomNumberGenerator.new()
var wal_template = load("res://objects/wal.tscn").instantiate()
var stab_template = load("res://objects/stab.tscn").instantiate()
var spawnInteval = 100
var distance_until_spawn_interval_goes_down = 400

#boss spawn variables
var giraffe_template = load("res://objects/giraffe.tscn").instantiate()

@onready var monsters = $Monsters

@onready var level_borders = $"../LevelBorders"


func _physics_process(delta):
	#spawn monsters
	spawnInteval = 50 - (int(level_borders.position.x) / distance_until_spawn_interval_goes_down) if spawnInteval > 1 else 1
	spawnTimer += 1
	if (spawnTimer >= spawnInteval):
		spawnTimer = 0;
		if (Globals.bossMode == false and monsters.get_child_count() < 100):
			var monsterType = random.randi_range(0, 3)
			
			if (monsterType < 3):
				#for i in range(0, 1, 1):
				var position = Vector2((level_borders.position.x + camera.get_viewport_rect().size.x / camera.zoom.x + 100), 
									   (random.randi_range(0, 1080)))
				var wal = wal_template.duplicate()
				wal.position = position
				monsters.add_child(wal)
			if (monsterType == 3):
				var position
				if (random.randf() < 0.6):
					position = Vector2((level_borders.position.x + camera.get_viewport_rect().size.x / camera.zoom.x + 100), 1080)
				else:
					position = Vector2((level_borders.position.x + camera.get_viewport_rect().size.x / camera.zoom.x + 100), 
									   stab_template.get_node(NodePath("CollisionShape2D")).shape.size.y * stab_template.get_node(NodePath("CollisionShape2D")).scale.y)
				var stab = stab_template.duplicate()
				stab.position = position
				monsters.add_child(stab)
	
	#spawn bosses
	if (level_borders.position.x >= 10000 and !Globals.giraffeBeaten and !Globals.bossMode):
		Globals.activateBossMode()
		var position = Vector2((level_borders.position.x + camera.get_viewport_rect().size.x / camera.zoom.x + 100), 
							1080 / 2)
		var giraffe = giraffe_template.duplicate()
		giraffe.position = position
		monsters.add_child(giraffe)
