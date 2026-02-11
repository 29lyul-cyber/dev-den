extends Area2D

@export var speed: float = 750
var pierce_remaining: int = 0 # Track how many more enemies this specific bullet can hit
var enemies_hit: Array = []   # Track which enemies this specific bullet has already hit

func _ready():
	# Get the CURRENT pierce count from the Global script the moment the bullet is created
	# We assume Global.gd has a variable named 'current_pierce_count' (int)
	pierce_remaining = Global.pierce_level
	
	# Connect to area_entered so we catch when another Area2D enters our hitbox
	# Callable syntax for Godot 4
	area_entered.connect(_on_area_entered)


func _physics_process(delta):
	# Move the bullet forward using its local Y axis (assuming sprite is pointing up/down)
	position -= transform.y * speed * delta


func _on_area_entered(area: Area2D):
	# Check if the colliding area belongs to an enemy group ("mobs")
	if area.is_in_group("mobs"):
		
		# Check if we have already damaged this specific enemy instance
		# 'area.owner' refers to the root node of the enemy scene (e.g. the CharacterBody2D/Node2D)
		if not enemies_hit.has(area.owner):
			
			# Apply damage or "kill the fish" logic here
			area.queue_free()  # Kill the enemy node
			
			var score_value: int = 10
			Global.add_score(score_value)
			
			# Add this enemy to the list so we don't hit it again if we stay inside its Area2D
			#enemies_hit.append(area.owner)
			
			# Handle the piercing logic:
			if pierce_remaining > 0:
				# If we have pierce shots left, decrement the counter and keep going
				pierce_remaining -= 1
				print("Piercing shot! Pierce remaining: ", pierce_remaining)
			else:
				# If pierce_remaining is 0, the bullet should be destroyed
				queue_free()
