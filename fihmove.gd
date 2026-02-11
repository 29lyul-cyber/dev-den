extends Area2D

@export var is_moving: bool = false
@export var is_moving_right: bool = false
@export var speed : float = 100
var current_speed : float = speed

var can_despawn: bool = true
func _physics_process(delta):
	if is_moving:  
		if is_moving_right:
			position -= transform.x * -current_speed * delta
		if !is_moving_right:
			position -= transform.x * current_speed * delta
	
func _ready():
	# Connect to the global signal when the player spawns
	Global.upgrade_applied.connect(_on_global_upgrade_applied)
	# Also apply the initial/current bonus just in case the game started with upgrades
	_update_speed() 

	start_despawn()


func _on_global_upgrade_applied(upgrade_id: String):
	# When any upgrade is applied, re-evaluate our stats based on global data
	_update_speed()

	# You could also use a match statement here if you only need to update specific stats

func _update_speed():
	# Recalculate speed using the base value and the global multiplier
	current_speed = speed * Global.fish_speed_bonus


func start_despawn():
	var timer = get_tree().create_timer(20)
	timer.timeout.connect(_on_despawn_timeout)
	


func _on_despawn_timeout():
	queue_free()
		
		
