extends CharacterBody2D

#@export var speed = 200
@export var speed: float = 200.0
var current_speed: float = speed
@export var friction = 1
@export var acceleration = 0.3
@export var bullet_scene : PackedScene 
@export var shoottimeout : float = 0.5
var current_shootcd : float = shoottimeout
var can_attack = true
var Mermi  = load("res://test.tscn")


func _ready():
	# Connect to the global signal when the player spawns
	Global.upgrade_applied.connect(_on_global_upgrade_applied)
	# Also apply the initial/current bonus just in case the game started with upgrades
	_update_speed() 
	_update_shoot_cd()

func _on_global_upgrade_applied(upgrade_id: String):
	# When any upgrade is applied, re-evaluate our stats based on global data
	_update_speed()
	_update_shoot_cd()
	# You could also use a match statement here if you only need to update specific stats

func _update_speed():
	# Recalculate speed using the base value and the global multiplier
	current_speed = speed * Global.current_speed_multiplier

func _update_shoot_cd():
	current_shootcd = shoottimeout * Global.fire_rate_level
	#print(current_shootcd)


func get_input():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	#var dir = Input.get_axis("up", "down")
	#velocity = transform.x * dir * speed
	if Input.is_action_just_pressed("shoot"):
		shoot()

	return input
	


  
func _physics_process(delta):
	get_input()
	
	move_and_slide()
	var direction = get_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * current_speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)

func shoot():

	if can_attack:
		can_attack = false
		get_tree().create_timer(current_shootcd).timeout.connect(func(): can_attack = true)
		var b = bullet_scene.instantiate()
		get_tree().root.add_child(b)
		b.transform = $Muzzle.global_transform
