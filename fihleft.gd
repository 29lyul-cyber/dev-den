extends Node2D

@export var fish_scene: PackedScene
@export var spawn_area_size: Vector2 = Vector2(400, 300)
@export var spawn_point: Vector2 = Vector2(0, 0)
@export var min_spawn_time: float = 0.5
@export var max_spawn_time: float = 2.0
@export var is_random: bool = false
var current_speed : float = min_spawn_time



#var pos: Vector2=Vector2(0,0)
var spawn_timer: float = 0.0
var next_spawn_in: float = 0.0
var rng = RandomNumberGenerator.new()


func _ready():
	if is_random:
		var _pos = get_random_spawn_position()
		rng.randomize()
		randomize()
	schedule_next_spawn()
	add_to_group("mobs")
	rng.randomize()
	# Example: spawn 5 fish at random positions from your sets
	#for i in range(5):
		#spawn_fish(get_random_spawn_position())

func _process(delta):
	spawn_timer += delta
	if spawn_timer >= next_spawn_in:
		spawn_fish(get_random_spawn_position())
		spawn_timer = 0.0
		schedule_next_spawn()

func schedule_next_spawn():
	next_spawn_in = randf_range(min_spawn_time, max_spawn_time)

func spawn_fish(pos: Vector2) -> void:
	if fish_scene == null:
		push_error("fish_scene is not assigned in the Spawner.")
		return
	var fish = fish_scene.instantiate() as Node2D
	# Use world coordinates if this spawner is in a different space
	fish.global_position = pos
	get_tree().current_scene.add_child(fish)

#func spawn_fish(x,y):
	#if not fish_scene:
		#push_warning("fish_scene not assigned!")
		#return
#
	#var fish = fish_scene.instantiate()
	#add_child(fish)
	##print("fish spawned")
#
	#var center = global_position
	#if is_random:
		##var pos = Vector2(
			###randf_range(-spawn_area_size.x / 2, spawn_area_size.x / 2),
			###randf_range(-spawn_area_size.y / 2, spawn_area_size.y / 2)
		##) + center
		#get_random_spawn_position()
		#fish.position = pos
	##if !is_random:
		##var pos = Vector2(spawn_point.x, spawn_point.y) + center
		##fish.position = pos
	###print(pos)



@export var spawn_sets := [
	[ Vector2(700, -80),  Vector2(700, -280)]
]


	# spawn_fish_at(pos)

func get_random_spawn_position() -> Vector2:
	var set_index = rng.randi_range(0, spawn_sets.size() - 1)
	var chosen_set = spawn_sets[set_index]
	var pos_index = rng.randi_range(0, chosen_set.size() - 1)
	return chosen_set[pos_index]
