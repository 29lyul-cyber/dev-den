extends Node

# Define a custom signal that passes the new score value
signal score_updated(new_score: int)

var current_score: int = 0

func add_score(amount: int):
	current_score += amount
	print("Score increased to: ", current_score)
	# Emit the signal whenever the score changes
	score_updated.emit(current_score)
# New signal to alert everything else that an upgrade just happened
signal upgrade_applied(upgrade_id: String)

# Variables to store the current level/state of upgrades
var current_speed_multiplier: float = 1.0
var fish_speed_bonus: float = 1
var fire_rate_level: float = 1
var pierce_level: int = 0
var score_level: float = 1
# ... etc ...

# Function to be called from your upgrade UI script
func apply_global_upgrade(upgrade_id: String):
	# Update the global state variables
	match upgrade_id:
		"p_speed":
			current_speed_multiplier += 0.3
			print("Global speed multiplier increased to: ", current_speed_multiplier)
		"f_speed":
			fish_speed_bonus += 0.2
			print("Global fish speed bonus increased to: ", fish_speed_bonus)
		"shootcd":
			fire_rate_level *= 0.5
			print("Global fire rate level increased to: ", fire_rate_level)
		"score":
			score_level += 0.2
			print("Global score_level level increased to: ", score_level)
		"pierce":
			pierce_level += 1
			print("Global pierce level increased to: ", pierce_level)
			# ... other cases ...
	# Emit a signal so other nodes know something changed
	emit_signal("upgrade_applied", upgrade_id)
