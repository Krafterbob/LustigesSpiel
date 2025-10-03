extends Node

#monster spawn variables
var spawnTimer = 0
var random = RandomNumberGenerator.new()
var wal_template = load("res://objects/wal.tscn").instantiate()
var stab_template = load("res://objects/stab.tscn").instantiate()
var stab_gorilla_template = load("res://objects/stabGorilla.tscn").instantiate()
var geflügelte_gekrönte_goldene_erdbeere_template = load("res://objects/geflügelte_gekrönte_goldene_erdbeere.tscn").instantiate()
var spawnIntevalInitial = 100
var spawnInteval = 100
var distance_until_spawn_interval_goes_down = 500
var max_monsters = 50

#boss spawn variables
var giraffe_template = load("res://objects/giraffe.tscn").instantiate()

@onready var monsters = $Monsters

@onready var level_borders = $"../LevelBorders"

func _init():
	spawnIntevalInitial = spawnIntevalInitial * Globals.defaultDifficultiy / Globals.difficultiy
	spawnInteval = spawnIntevalInitial
	distance_until_spawn_interval_goes_down = distance_until_spawn_interval_goes_down * Globals.defaultDifficultiy / Globals.difficultiy

func _physics_process(delta):
	#spawn monsters
	spawnInteval = spawnIntevalInitial - (int(level_borders.position.x) / distance_until_spawn_interval_goes_down) if spawnInteval > 1 else 1
	spawnTimer += 1
	if (spawnTimer >= spawnInteval):
		spawnTimer = 0;
		if (Globals.bossMode == false and monsters.get_child_count() < max_monsters):
			var monsterType = random.randi_range(0, 60)
			
			if (monsterType < 40):
				#for i in range(0, 1, 1):
				var position = Vector2((level_borders.position.x + camera.get_viewport_rect().size.x / camera.zoom.x + 100), 
									   (random.randi_range(0, 1080)))
				var wal = wal_template.duplicate()
				wal.position = position
				monsters.add_child(wal)
				
			if (monsterType >= 40 and monsterType < 60):
				var position
				if (random.randf() < 0.8):
					position = Vector2((level_borders.position.x + camera.get_viewport_rect().size.x / camera.zoom.x + 100), 1080)
				else:
					position = Vector2((level_borders.position.x + camera.get_viewport_rect().size.x / camera.zoom.x + 100), 
									   stab_template.get_node(NodePath("CollisionShape2D")).shape.size.y * stab_template.get_node(NodePath("CollisionShape2D")).scale.y)
				var stab = stab_template.duplicate() if random.randf() < 0.9 else stab_gorilla_template.duplicate()
				stab.position = position
				monsters.add_child(stab)
				
			if (monsterType == 60):
				var position = Vector2(level_borders.position.x + camera.get_viewport_rect().size.x / camera.zoom.x, 1080 / 2)
				var geflügelte_gekrönte_goldene_erdbeere = geflügelte_gekrönte_goldene_erdbeere_template.duplicate()
				geflügelte_gekrönte_goldene_erdbeere.position = position
				monsters.add_child(geflügelte_gekrönte_goldene_erdbeere)
	
	#spawn bosses                   30000
	if (level_borders.position.x >= 30000 and !Globals.giraffeBeaten and !Globals.bossMode):
		Globals.activateBossMode()
		var position = Vector2((level_borders.position.x + camera.get_viewport_rect().size.x / camera.zoom.x + 100), 
							1080 / 2)
		var giraffe = giraffe_template.duplicate()
		giraffe.position = position
		monsters.add_child(giraffe)
