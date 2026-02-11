extends Label

var score_checkpoint: int
var final_score : float = 0

func _ready():
	# Set initial text
	text = "Score: " + str(final_score)
	# Connect the global signal to a function in this script
	Global.score_updated.connect(_on_global_score_updated)
# Connect to the global signal when the player spawns
	Global.upgrade_applied.connect(_on_global_upgrade_applied)
	# Also apply the initial/current bonus just in case the game started with upgrades
	_update_score_bonus() 

func _on_global_score_updated(new_score: int):
	# This function is called every time the signal is emitted
	text = "Score: " + str(new_score*Global.score_level)
		
		


func _on_global_upgrade_applied(upgrade_id: String):
	# When any upgrade is applied, re-evaluate our stats based on global data
	_update_score_bonus() 
	# You could also use a match statement here if you only need to update specific stats

func _update_score_bonus():
	# Recalculate speed using the base value and the global multiplier
	final_score = Global.current_score * Global.score_level
