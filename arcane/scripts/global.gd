extends Node
var gold : int
var organic : int
var food : int
var chemical : int
var drug : int
var overworld_people : int
var underworld_people : int
var mood_overworld : int
var mood_underworld : int



# Buildings in Overworld: Farm, Butcher, Overworld City Hall, Apartments, Hospital

# Buildings in Underworld: Mine, Underground Lab, Underworld City Hall, Huts, Sickbay, Dump


var buildable_tiles := {
	"Apartment": {
		"centers": [
			Vector2i(-4,10),
			Vector2i(-4,6),
			Vector2i(-4,2)
			
		],
		"built_tiles": [],
		"levels": {}
	}
}

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
	updateUI()

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
	updateUI()
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

func updateUI():
	$"Node2D/Static UI/Panel/Stats/statsOver/organictxt".text= str(organic)
	$"Node2D/Static UI/Panel/Stats/statsOver/foodtxt".text=str(food)
	$"Node2D/Static UI/Panel/Stats/statsUnder/chemic".text=str(chemical)
	$"Node2D/Static UI/Panel/Stats/statsUnder/drugs".text=str(drug)
	pass
	
func food_tick():
	pass
	
func drug_tick():
	pass
	
func organic_tick():
	pass
	
func chemical_tick():
	pass
