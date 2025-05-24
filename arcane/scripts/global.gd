extends Node
var gold
var organic
var food
var chemical
var drug
var overworld_people
var underworld_people
var mood_overworld
var mood_underworld

func _ready() -> void:
	gold = 100
	organic = 0
	food = 50
	chemical = 0
	drug = 50
	overworld_people = 10
	underworld_people = 10
	mood_overworld = 50 # mood from 0-100, 100 is shit, 0 is great
	mood_underworld = 50

func add_gold(val):
	gold += val
	
func add_organic(val):
	organic += val
	
func add_food(val):
	food += val
	
func add_chemical(val):
	chemical += val
	
func add_drug(val):
	drug += val
	
func add_overworld_people(val):
	overworld_people += val
	
func add_underworld_people(val):
	underworld_people += val
	


func _on_timer_timeout() -> void:
	print("_on_timer_timeout")
	check_mood()
	pass # Replace with function body.
	
	
# checks mood between worlds, and updates if nessecary. 
# mood gets worse when resources are not supplied
func check_mood():
	print("check_mood")
	print(str(food) + " food/ " + str(drug) + " drug")
	if(food >= overworld_people):
		food -= overworld_people
	else:
		mood_overworld += 5
	if(food >= underworld_people):
		food -= underworld_people
	else:
		mood_underworld += 5
	if(drug >= underworld_people):
		drug -= underworld_people
	else:
		mood_underworld += 5
	if(drug >= overworld_people):
		drug -= overworld_people
	else:
		mood_overworld += 5
	print(mood_overworld)
	print(mood_underworld)
