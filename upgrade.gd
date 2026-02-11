extends Control

@onready var button_1 = $upgrade_bg/upgrade1
@onready var button_2 = $upgrade_bg/upgrade2
@onready var button_3 = $upgrade_bg/upgrade3
var buttons = [] # Array to hold all button references

var final_score : float = 0
var round : int = 0
var round_multiplier : float = 1

var all_upgrades = [
	{"name": "Efficient Fins", "description": "Increases movement speed by 20%.", "id": "p_speed"},
	{"name": "Fast Fih", "description": "Increases fish speed by 20%.", "id": "f_speed"},
	{"name": "Shoot CD", "description": "Increases doubles attack speed.", "id": "shootcd"},
	{"name": "Pierce +1", "description": "Attacks penetrate enemies by 1 more.", "id": "pierce"},
	{"name": "Score x1.2", "description": "Increases score per fish by 20%.", "id": "score"}
]

# A reference to the current selection of upgrades displayed
var current_upgrades = [] 

func _ready():
	# Connect the global signal to a function in this script
	Global.score_updated.connect(_on_global_score_updated)
# Add buttons to array for easy iteration
	buttons.append(button_1)
	buttons.append(button_2)
	buttons.append(button_3)
	
	# Connect signals from all buttons to a single handler function
	for button in buttons:
		# Pass the button itself as an argument to the handler function
		button.pressed.connect(_on_upgrade_button_pressed.bind(button)) 


func _on_global_score_updated(new_score: int):
	# This function is called every time the signal is emitted
	final_score = (new_score-(round*100))
	if final_score >= 100/Global.score_level:
		show_random_upgrades()
		round=round+1
		#round_multiplier=round_multiplier*1.2
		
	#print("actual",20*round_multiplier)
	#print("0", new_score-(round*2                          a  0 * round_multiplier))
	#print("needed", round_multiplier*20)
	#print(round_multiplier)
	print((new_score-(round*100))*Global.score_level)
	print(final_score)

func hide_upgrade_ui():
	self.visible = false
	# Unpause the game
	get_tree().paused = false

# Connect your buttons to this script with functions like _on_upgrade_button_pressed()



#func _on_upgrade_3_pressed() -> void:
	#print("Button3 was pressed! Function executed.")
	#
#
#func _on_upgrade_2_pressed() -> void:
	#print("Button2 was pressed! Function executed.")
#
#
#func _on_upgrade_1_pressed() -> void:
	#print("Button1 was pressed! Function executed.")
	
func show_random_upgrades():
	self.visible = true
	# You might want to pause the game here
	get_tree().paused = true
	# 1. Shuffle a copy of the list to avoid modifying the original list
	var available_upgrades = all_upgrades.duplicate()
	available_upgrades.shuffle()
	# 2. Clear previous selections
	current_upgrades.clear()
	# 3. Pick the top 3 (or the number of buttons you have) unique upgrades
	for i in range(buttons.size()):
		if i < available_upgrades.size():
			var upgrade = available_upgrades[i]
			current_upgrades.append(upgrade)
			# Update the button text (and maybe a description label)
			buttons[i].text = upgrade.name
		else:
			# Hide the button if not enough upgrades are available
			buttons[i].hide()

		$upgrade_bg.show()
func _on_upgrade_button_pressed(button_pressed):
	# Logic for applying the upgrade
	hide_upgrade_ui()
	# Find which button was pressed and get the corresponding upgrade data
	var button_index = buttons.find(button_pressed)
	if button_index != -1 and button_index < current_upgrades.size():
		var chosen_upgrade = current_upgrades[button_index]
		apply_upgrade(chosen_upgrade.id)
		
		# Hide the upgrade menu after selection
		$upgrade_bg.hide()

func apply_upgrade(upgrade_id: String):
	# Delegate the actual upgrade application to the Global script
	Global.apply_global_upgrade(upgrade_id)
	print(upgrade_id)
