extends Node
@export var gold : int


var organic : int
var food : int
var overworld_people : int
var overworld_people_max : int
var overworld_sick : int
var mood_overworld : int


var chemical : int
var drug : int
var underworld_people : int
var underworld_people_max : int
var underworld_sick : int
var mood_underworld : int
var trash : int

var daycounter: int
var startLevel :int
var startUpgradeCost :int
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
		"levels": { },
		"upgradeCosts":  [10,20,50,200,500,1000],
		},
	"Hut": {
		"centers": [
			Vector2i(-10,10),
			Vector2i(-4,6),
			Vector2i(-4,2)
			
		],
		"built_tiles": [],
		"levels": { },
		"upgradeCosts":  [100,200,500,1000,2000],
		},
	"Hospital": {
		"centers": [
			Vector2i(-10,10),
			Vector2i(-4,6),
			Vector2i(-4,2)
			
		],
		"built_tiles": [],
		"levels": { },
		"upgradeCosts":  [100,200,500,1000,2000],
		},
	"Sickbay": {
		"centers": [
			Vector2i(-10,10),
			Vector2i(-4,6),
			Vector2i(-4,2)
			
		],
		"built_tiles": [],
		"levels": { },
		"upgradeCosts":  [100,200,500,1000,2000],
		},
	"Farm": {
		"centers": [
			Vector2i(-10,10),
			Vector2i(-4,6),
			Vector2i(-4,2)
			
		],
		"built_tiles": [],
		"levels": { },
		"upgradeCosts":  [100,200,500,1000,2000],
		},
	"Butcher": {
		"centers": [
			Vector2i(-10,10),
			Vector2i(-4,6),
			Vector2i(-4,2)
			
		],
		"built_tiles": [],
		"levels": { },
		"upgradeCosts":  [100,200,500,1000,2000],
		},
	"Mine": {
		"centers": [
			Vector2i(-10,10),
			Vector2i(-4,6),
			Vector2i(-4,2)
			
		],
		"built_tiles": [],
		"levels": { },
		"upgradeCosts":  [100,200,500,1000,2000],
		},
	"Lab": {
		"centers": [
			Vector2i(-10,10),
			Vector2i(-4,6),
			Vector2i(-4,2)
			
		],
		"built_tiles": [],
		"levels": { },
		"upgradeCosts":  [100,200,500,1000,2000],
		},
	"Dump": {
		"centers": [
			Vector2i(-10,10),
			Vector2i(-4,6),
			Vector2i(-4,2)
			
		],
		"built_tiles": [],
		"levels": { },
		"upgradeCosts":  [100,200,500,1000,2000],
		},
	"Overworld": {
		"centers": [
			Vector2i(-10,10),
			Vector2i(-4,6),
			Vector2i(-4,2)
			
		],
		"built_tiles": [],
		"levels": { },
		"upgradeCosts":  [100,200,500,1000,2000],
		},
	"Underworld": {
		"centers": [
			Vector2i(-10,10),
			Vector2i(-4,6),
			Vector2i(-4,2)
			
		],
		"built_tiles": [],
		"levels": { },
		"upgradeCosts":  [100,200,500,1000,2000],
		},
	}

func _ready() -> void:
	startLevel = 0
	startUpgradeCost = 1
	gold = 100
	organic = 0
	food = 50
	chemical = 0
	drug = 50
	overworld_people = 10
	overworld_people_max = 15
	underworld_people = 10
	underworld_people_max = 15
	mood_overworld = 80 # mood from 0-100, 100 is shit, 0 is great
	mood_underworld = 50
	overworld_sick = 0
	underworld_sick = 0
	updateUI()

func add_gold(val):
	if val * (-1) <= gold:
		gold += val
	
func add_organic(val):
	if val * (-1) <= organic:
		organic += val
	
func add_food(val):
	if val * (-1) <= food:
		food += val
	
func add_chemical(val):
	if val * (-1) <= chemical:
		chemical += val
	
func add_drug(val):
	if val * (-1) <= drug:
		drug += val
	
func add_overworld_people(val):
	if val * (-1) <= overworld_people:
		overworld_people += val
	
func add_underworld_people(val):
	if val * (-1) <= underworld_people:
		underworld_people += val
	

# quasi wie update, nur nicht jeden frame
func _on_timer_timeout() -> void:
	print("_on_timer_timeout")
	
	calculate_population()
	calculate_gold()
	hospital_tick()
	sickbay_tick()
	organic_tick()
	food_tick()
	chemical_tick()
	drug_tick()
	dump_tick()
	
	
	consume()
	updateUI()
	pass # Replace with function body.
	
	
# checks mood between worlds, and updates if nessecary. 
# mood gets worse when resources are not supplied
func consume():
	print("consume")
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
	$"Node2D/Static UI/Panel/Stats/statsOver/populationovertxt".text=str(overworld_people)

	$"Node2D/Static UI/Panel/Stats/statsUnder/chemic".text=str(chemical)
	$"Node2D/Static UI/Panel/Stats/statsUnder/drugs".text=str(drug)
	$"Node2D/Static UI/Panel/Stats/statsUnder/populationundertxt".text=str(underworld_people)

	pass

func calculate_population():
	if not buildable_tiles["Apartment"]["levels"].is_empty():
		var new_people
		for elem in buildable_tiles["Apartment"]["levels"]:
			match elem:
				"0":
					new_people += 1
				"1":
					new_people += 5
				"2":
					new_people += 20
		if overworld_people < overworld_people_max:
			
			overworld_people += new_people
			if overworld_people > overworld_people_max:
				overworld_people = overworld_people_max
			
		print("yo")
	if not buildable_tiles["Hut"]["levels"].is_empty():
		var new_people
		for elem in buildable_tiles["Hut"]["levels"]:
			match elem:
				"0":
					new_people += 1
				"1":
					new_people += 5
				"2":
					new_people += 20
		if underworld_people < underworld_people_max:
			
			underworld_people += new_people
			if underworld_people > underworld_people_max:
				underworld_people = underworld_people_max
			
	pass

func overworld_people_available() -> float:
	return (overworld_people - overworld_sick) / overworld_people

func underworld_people_available() -> float:
	return (overworld_people - overworld_sick) / overworld_people

func organic_tick():
	if not buildable_tiles["Farm"]["levels"].is_empty():
		var modifier
		for elem in buildable_tiles["Farm"]["levels"]:
			match elem:
				"0":
					modifier += 10
				"1":
					modifier += 20
				"2":
					modifier += 40	
		
		add_organic(int(modifier * overworld_people_available()))
		
	pass
	
func food_tick():
	if buildable_tiles["Butcher"]["levels"].is_empty():
		var modifier
		for elem in buildable_tiles["Butcher"]["levels"]:
			match elem:
				"0":
					modifier += 10
				"1":
					modifier += 20
				"2":
					modifier += 40	
		modifier *= int(overworld_people_available())
		if modifier > organic:
			modifier = organic
		add_organic(modifier)
	pass
	
func drug_tick():
	if buildable_tiles["Lab"]["levels"].is_empty():
		var modifier
		for elem in buildable_tiles["Lab"]["levels"]:
			match elem:
				"0":
					modifier += 10
				"1":
					modifier += 20
				"2":
					modifier += 40	
		modifier *= int(underworld_people_available())
		if modifier > chemical:
			modifier = chemical
		add_organic(modifier)
	
	pass
	
func chemical_tick():
	if buildable_tiles["Mine"]["levels"].is_empty():
		var modifier
		for elem in buildable_tiles["Mine"]["levels"]:
			match elem:
				"0":
					modifier += 10
				"1":
					modifier += 20
				"2":
					modifier += 40	

		add_chemical(int(modifier * underworld_people_available()))
		
	pass
	
func hospital_tick():
	if buildable_tiles["Hospital"]["levels"].is_empty():
		pass
	pass
	
func sickbay_tick():
	if buildable_tiles["Sickbay"]["levels"].is_empty():
		pass
	pass
	
func dump_tick():
	if buildable_tiles["Dump"]["levels"].is_empty():
		pass
	pass
	

func calculate_gold():
	gold += overworld_people + underworld_people
	pass

func _on_clock_three_day_event() -> void:
	# Timer pausieren
	$Node2D/Camera2D/Clock/DayTimer.paused = true
	$Node2D/Camera2D/Clock/UpdateTimer.paused = true

	var card1 = card_pool.pick_random()
	var card2 = card_pool.pick_random()
	while card2 == card1:
		card2 = card_pool.pick_random()

	var ui = $Node2D/Camera2D/CardEventUI
	ui.get_node("Card1btn").get_node("Card1lbl").text = card1.description
	ui.get_node("Card2btn").get_node("Card2lbl").text = card2.description
	ui.get_node("Card1btn").get_node("Card1Titel").text = card1.name
	ui.get_node("Card2btn").get_node("Card2Titel").text = card2.name



	ui.get_node("Card1btn").pressed.connect(func():
		card1.effect.call()
		ui.visible = false
		resume_timers()
		updateUI()
	)

	ui.get_node("Card2btn").pressed.connect(func():
		card2.effect.call()
		ui.visible = false
		resume_timers()
		updateUI()
	)

	ui.visible = true
	
	
func resume_timers():
	$"Node2D/Static UI/Panel/Stats/Clock/DayTimer".paused = false
	$"Node2D/Static UI/Panel/Stats/Clock/UpdateTimer".paused = false

#TODO vlt noch Grafik oder so einfügen 
var card_pool = [
	{
	"name": "Krankheitswelle",
	"description": "Stimmung Unterwelt +10",
	"effect": func(): mood_underworld += 10
	},
	{
	"name": "Fruchtbare Ernte",
	"description": "Essen +25",
	"effect": func(): food += 25
	},
	{
	"name": "Kontamination",
	"description": "Chemikalien -10, Stimmung Oberwelt +5",
	"effect": func():
	chemical = max(0, chemical - 10)
	mood_overworld += 5
	},
]
