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
var pollution : int

var daycounter: int
var startLevel :int
var startUpgradeCost :int


# Buildings in Overworld: Farm, Butcher, Overworld City Hall, Apartments, Hospital

# Buildings in Underworld: Mine, Underground Lab, Underworld City Hall, Huts, Sickbay, Dump


var buildable_tiles := {
	"Apartment": {
		"centers": [
			Vector2i(-7,-7),
			Vector2i(-7,-13),
			Vector2i(-7,-19),
			Vector2i(-25,-19),
			
		],
		"built_tiles": [],
		"levels": { },
		"upgradeCosts":  [50,100,200,500,2000,5000,10000],
		},
	"Hut": {
		"centers": [
			Vector2i(50,82),
			Vector2i(50,82),
			Vector2i(50,77),
			Vector2i(50,72)
			
		],
		"built_tiles": [],
		"levels": { },
		"upgradeCosts":  [50,100,200,500,2000,5000],
		},
	"Hospital": {
		"centers": [
			Vector2i(-13,10),
			
		],
		"built_tiles": [],
		"levels": { },
		"upgradeCosts":  [50,100,200,500,2000,5000],
		},
	"Sickbay": {
		"centers": [
			Vector2i(74,90),
			
		],
		"built_tiles": [],
		"levels": { },
		"upgradeCosts":  [50,100,200,500,2000,5000],
		},
	"Farm": {
		"centers": [
			Vector2i(-4,11),
			Vector2i(-4,5),
			Vector2i(-4,-27),Vector2i(20,9)
			
		],
		"built_tiles": [],
		"levels": { },
		"upgradeCosts":  [25,50,100,200,500,1000],
		},
	"Butcher": {
		"centers": [
			Vector2i(4,-7),
			Vector2i(4,-13),
			Vector2i(4,-18),
			Vector2i(12,6),
			
		],
		"built_tiles": [],
		"levels": { },
		"upgradeCosts":  [25,50,100,200,500,1000],
		},
	"Mine": {
		"centers": [Vector2i(77,81),Vector2i(64,84),Vector2i(64,75),
			
		],
		"built_tiles": [],
		"levels": { },
		"upgradeCosts": [25,50,100,200,500,1000],
		},
	"Lab": {
		"centers": [Vector2i(79,63),Vector2i(67,63),Vector2i(65,41),

			
		],
		"built_tiles": [],
		"levels": { },
		"upgradeCosts":  [25,50,100,200,500,1000],
		},
	"Dump": {
		"centers": [Vector2i(53,43),Vector2i(39,60),

			
		],
		"built_tiles": [],
		"levels": { },
		"upgradeCosts":  [50,10,20,50,200,500,1000],
		},
	"Overworld": {
		"centers": [
			Vector2i(-17,-22),
			
		],
		"built_tiles": [],
		"levels": { },
		"upgradeCosts":  [50,100,200,50,200,500,1000],
		},
	"Underworld": {
		"centers": [Vector2i(50,54),

			
		],
		"built_tiles": [],
		"levels": { },
		"upgradeCosts":  [50,100,200,50,200,500,1000],
		},
	}

func _ready() -> void:
	startLevel = 0
	startUpgradeCost = 1
	gold = 150
	organic = 0
	food = 10
	chemical = 0
	drug = 10
	overworld_people = 5
	overworld_people_max = 5
	underworld_people = 5
	underworld_people_max = 5
	mood_overworld = 30 # mood from 0-100, 100 is shit, 0 is great
	mood_underworld = 60
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
		
		
func spend_gold (val):
	add_gold(-val)

# quasi wie update, nur nicht jeden frame
func _on_timer_timeout() -> void:
	print ("wrong update")
	pass # Replace with function body.
	
	
# checks mood between worlds, and updates if nessecary. 
# mood gets worse when resources are not supplied
func consume():
	print("consume")
	print(str(food) + " food/ " + str(drug) + " drug")
	if(food >= overworld_people):
		food -= overworld_people
		mood_overworld -= 1
	else:
		mood_overworld += 2
	if(food >= underworld_people):
		food -= underworld_people
		mood_underworld -= 1
	else:
		mood_underworld += 2
	if(drug >= underworld_people):
		drug -= underworld_people
		mood_underworld -= 1
	else:
		mood_underworld += 2
	if(drug >= overworld_people):
		drug -= overworld_people
		mood_overworld -=1
	else:
		mood_overworld += 5
	print(mood_overworld)
	print(mood_underworld)


func updateUI():
	$"Node2D/Static UI/Panel/Stats/statsOver/overworld_people/people/peopletxt".text = str(overworld_people-overworld_sick)
	$"Node2D/Static UI/Panel/Stats/statsOver/overworld_sick/sickpeople/sickpeopletxt".text=str(overworld_sick)
	$"Node2D/Static UI/Panel/Stats/statsOver/overworld_people_max/people_max/overworld_people_maxtxt".text=str(overworld_people_max)
	$"Node2D/Static UI/Panel/Stats/statsOver/organic/org/organictxt".text=str(organic)
	$"Node2D/Static UI/Panel/Stats/statsOver/food/food/foodtxt".text=str(food)
	$"Node2D/Static UI/Panel/Stats/statsOver/gold/gold/goldtxt".text=str(gold)
	
	
	$"Node2D/Static UI/Panel/Stats/statsUnder/underworld_people/people/underpeopletxt".text =str(underworld_people-underworld_sick)
	$"Node2D/Static UI/Panel/Stats/statsUnder/underworld_sick/sickpeople/underpeopletxt".text= str(underworld_sick)
	$"Node2D/Static UI/Panel/Stats/statsUnder/underworld_people_max/people_max/underworld_people_maxtxt".text=str(underworld_people_max)
	$"Node2D/Static UI/Panel/Stats/statsUnder/chemic/chemic/chemtxt".text=str(chemical)
	$"Node2D/Static UI/Panel/Stats/statsUnder/drug/drug/drugtxt".text=str(drug)
	$"Node2D/Static UI/Panel/Stats/statsUnder/trash/trash/trashtxt".text=str(trash)
	
	$"Node2D/Static UI/Panel/Stats/Control/Button".update_mood_pointer()
	$Node2D/Camera2D/Clock._update_ui()
	pass

func calculate_population():
	if overworld_people <= 0 || underworld_people <= 0:
		get_tree().change_scene_to_file("res://screens/endScreen.tscn")

	# Apartments (Overworld)
	if not buildable_tiles["Apartment"]["levels"].is_empty():
		for center in buildable_tiles["Apartment"]["levels"].keys():
			if overworld_people >= overworld_people_max:
				break  # Max erreicht – nichts mehr hinzufügen

			var level = int(buildable_tiles["Apartment"]["levels"].get(center, 0))
			var people_gain = 0

			match level:
				0:
					people_gain = 1
				1:
					people_gain = 1
				2:
					people_gain = 1
				3:
					people_gain = 1
				4:
					people_gain = 1
				5:
					people_gain = 1

			var available_space = overworld_people_max - overworld_people
			overworld_people += min(people_gain, available_space)

	# Hütten (Underworld)
	if not buildable_tiles["Hut"]["levels"].is_empty():
		for center in buildable_tiles["Hut"]["levels"].keys():
			if underworld_people >= underworld_people_max:
				break

			var level = int(buildable_tiles["Hut"]["levels"].get(center, 0))
			var people_gain = 0

			match level:
				0:
					people_gain = 1
				1:
					people_gain = 1
				2:
					people_gain = 20
				3:
					people_gain = 40
				4:
					people_gain = 70
				5:
					people_gain = 100

			var available_space = underworld_people_max - underworld_people
			underworld_people += min(people_gain, available_space)





func overworld_people_available() -> float:
	if overworld_people - overworld_sick <= 0:
		overworld_people + 1
	return (overworld_people - overworld_sick) / overworld_people

func underworld_people_available() -> float:
	return (overworld_people - overworld_sick) / overworld_people
	
	
func pollution_tick():
	# Konfigurierbare Schwellen
	var pollution_threshold := 100
	var trash_pollution_rate := 1  # z. B. 1 Punkt Pollution pro 1 Trash

	# Pollution wächst durch Trash
	pollution += trash * trash_pollution_rate

	# Mood-Malus bei hoher Pollution
	if pollution >= pollution_threshold:
		var mood_penalty := int((pollution - pollution_threshold) * 0.1)  # z. B. -1 Mood je 10 Punkte über Limit
		mood_overworld += mood_penalty
		print("Pollution hoch! Stimmung der Oberwelt gesenkt um ", mood_penalty)

	# Pollution begrenzen (optional)
	pollution = clamp(pollution, 0, 500)
	
	
func pollution_infect_tick():
	var pollution_threshold := 10
	var max_sick_per_tick := 5  # Begrenzung pro Tick
	
	# Wenn Pollution zu hoch ist, beginne Infektion
	if pollution >= pollution_threshold:
		var excess_pollution := pollution - pollution_threshold

		# z. B. 1 zusätzliche Krankheit pro 20 Pollution über dem Limit
		var new_sick := int(excess_pollution / 20.0)

		# Begrenzen, damit nicht zu viele auf einmal krank werden
		new_sick = clamp(new_sick, 0, max_sick_per_tick)

		print("Neue Kranke durch Pollution:", new_sick, " → Gesamt:", overworld_sick)



func organic_tick():
	if not buildable_tiles["Farm"]["levels"].is_empty():
		var modifier = 1
		for level in buildable_tiles["Farm"]["levels"].values():
			match int(level):
				0:
					modifier += 1
				1:
					modifier += 5
					trash += 2
				2:
					modifier += 20	
					trash += 7
		add_organic(int(modifier * overworld_people_available()))
		
		
	
func food_tick():
	if not buildable_tiles["Butcher"]["levels"].is_empty():
		var modifier = 1
		for level in buildable_tiles["Butcher"]["levels"].values():
			match int(level):
				0:
					modifier += 2
				1:
					modifier += 20
					trash += 5
				2:
					modifier += 40	
					trash += 10
		modifier *= int(overworld_people_available())
		if modifier > organic:
			modifier = organic
		add_food(modifier)
		add_organic(-modifier)

	
func drug_tick():
	if not buildable_tiles["Lab"]["levels"].is_empty():
		var modifier = 1
		for level in buildable_tiles["Lab"]["levels"].values():
			match int(level):
				0:
					modifier += 2
				1:
					modifier += 10
					pollution += 5
				2:
					modifier += 40	
					pollution += 10
		modifier *= int(underworld_people_available())
		if modifier > chemical:
			modifier = chemical
		add_drug(modifier)
		add_chemical(-modifier)

	
func chemical_tick():
	if not buildable_tiles["Mine"]["levels"].is_empty():
		var modifier = 1
		for level in buildable_tiles["Mine"]["levels"].values():
			match int(level):
				0:
					modifier += 1
				1:
					modifier += 5
					pollution += 1
				2:
					modifier += 20	
					pollution += 2
		add_chemical(int(modifier * underworld_people_available()))

	
func hospital_tick():
	if not buildable_tiles["Hospital"]["levels"].is_empty():
		var modifier = 1
		for level in buildable_tiles["Hospital"]["levels"].values():
			match int(level):
				0:
					modifier += 1
				1:
					modifier += 5
				2:
					modifier += 10
		if overworld_sick < modifier:
			overworld_sick = 0
		else:
			overworld_sick -= modifier 

	
func sickbay_tick():
	if not buildable_tiles["Sickbay"]["levels"].is_empty():
		var modifier = 1
		for level in buildable_tiles["Sickbay"]["levels"].values():
			match int(level):
				0:
					modifier += 1
				1:
					modifier += 5
				2:
					modifier += 10
		if underworld_sick < modifier:
			underworld_sick = 0
		else:
			underworld_sick -= modifier 

	
func dump_tick():
	if buildable_tiles["Dump"]["levels"].is_empty():
		return  # Kein aktiver Dump gebaut

	var total_reduction := 0

	for level in buildable_tiles["Dump"]["levels"].values():
		match int(level):
			0:
				total_reduction += 1
			1:
				total_reduction += 15
			2:
				total_reduction += 30
			3:
				total_reduction += 60
			4:
				total_reduction += 80
			_:
				total_reduction += 150  # Für Level 5+

	trash = max(0, trash - total_reduction)
	print("🗑️ Müll reduziert um:", total_reduction, " → Neuer Stand:", trash)


	

func calculate_gold():
	gold += (overworld_people + underworld_people)/2
	pass


func _on_clock_three_day_event() -> void:
	# Timer pausieren
	$Node2D/Camera2D/Clock/DayTimer.paused = true
	$Node2D/Camera2D/Clock/UpdateTimer.paused = true
	$Node2D/Camera2D/Clock/ResourceTimer.paused = true

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
	$Node2D/Camera2D/Clock/DayTimer.paused = false
	$"Node2D/Camera2D/Clock/UpdateTimer".paused = false
	$Node2D/Camera2D/Clock/ResourceTimer.paused = false

#TODO vlt noch Grafik oder so einfügen 
var card_pool = [
	{
		"name": "Attack on the Dam",
		"description": "River pollution increased.\nEffect: +30 pollution\nAn attack on the dam causes uncontrolled spread of polluted water.",
		"effect": func(): pollution += 30
	},
	{
		"name": "The Rats Have Arrived",
		"description": "Waste increases heavily.\nEffect: +50 trash\nA rat infestation hits the dump site.",
		"effect": func(): trash += 50
	},
	{
		"name": "Great Tit Breeding",
		"description": "Farm productivity decreased.\nEffect: -10 organic\nThe rare Great Tit starts breeding on the cow pasture, forcing evacuation.",
		"effect": func(): organic -= 10
	},
	{
		"name": "Cock-of-the-Rock Emergency",
		"description": "Butcher productivity decreased.\nEffect: -10 food\nThe butcher gets bombed by a bird. He needs a break now.",
		"effect": func(): food -= 10
	},
	{
		"name": "Boobies in Danger",
		"description": "Lab productivity decreased.\nEffect: -10 drug\nSick blue-footed boobies require lab treatment, reducing productivity.",
		"effect": func(): drug -= 10
	},
	{
		"name": "Flying Fox of Terror",
		"description": "Mine productivity decreased.\nEffect: -10 chemical\nA terrifying bat-like creature drives workers out of the mines.",
		"effect": func(): chemical -= 10
	},
	{
		"name": "John Loglet",
		"description": "Farm productivity increased, happiness overworld -.\nEffect: +20 organic, +5 mood overworld\nA mysterious visionary boosts farm output but is disliked by the people.",
		"effect": func(): organic += 20; mood_overworld += 5
	},
	{
		"name": "Schmelon Kusk",
		"description": "Lab productivity increased, happiness underworld -.\nEffect: +20 drug, +5 mood underworld\nA mysterious visionary boosts lab output but is disliked underground.",
		"effect": func(): drug += 20; mood_underworld += 5
	},
	{
		"name": "Dr. Mike Cleanly",
		"description": "Mine productivity increased, happiness underworld -.\nEffect: +20 chemical, +5 mood underworld\nA mysterious visionary boosts mining, but gets on everyone's nerves.",
		"effect": func(): chemical += 20; mood_underworld += 5
	},
	{
		"name": "Ronald Dump",
		"description": "Butcher productivity increased, happiness overworld -.\nEffect: +20 food, +5 mood overworld\nA visionary shows up with meat ideas. The people are not amused.",
		"effect": func(): food += 20; mood_overworld += 5
	},
	{
		"name": "Alligator Raid",
		"description": "Cows lost.\nEffect: -20 organic\nHungry gators take a bite out of your livestock.",
		"effect": func(): organic = max(0, organic - 20)
	},
	{
		"name": "The Rolling Stoned",
		"description": "Food consumption spike.\nEffect: -30 food\nA group of very high students clean out your storage.",
		"effect": func(): food = max(0, food - 30)
	},
	{
		"name": "Student Visit Day",
		"description": "Chemical reserves damaged.\nEffect: -30 chemical\nSchool kids accidentally set the chemical storage on fire.",
		"effect": func(): chemical = max(0, chemical - 30)
	},
	{
		"name": "Warehouse Rave",
		"description": "Drugs mysteriously gone.\nEffect: -30 drug\nA rave inside the medical storage leads to mysterious shortages.",
		"effect": func(): drug = max(0, drug - 30)
	},
	{
		"name": "Mine Accident",
		"description": "Underworld population loss.\nEffect: -5 underworld population\nA cave-in crushes several workers underground.",
		"effect": func(): underworld_people = max(0, underworld_people - 5)
	},
	{
		"name": "The Butcher Goes Crazy",
		"description": "Overworld population loss.\nEffect: -5 overworld population\nThe butcher suffers a psychotic break and turns on the people.",
		"effect": func(): overworld_people = max(0, overworld_people - 5)
	}
]

func end_game(reason: String, is_win: bool):
	# Timer pausieren
	print("Spiel beendet:", reason, "Win:", is_win)  # <- Debug

	$Node2D/Camera2D/Clock/DayTimer.paused = true
	$Node2D/Camera2D/Clock/UpdateTimer.paused = true
	$Node2D/Camera2D/Clock/ResourceTimer.paused = true

	# Endscreen anzeigen
	var screen = $Node2D/Camera2D/endScreen
	screen.show_end(reason, is_win)



func check_end_conditions():
	var combined_mood = mood_underworld + mood_overworld

	# Lose: Bevölkerung = 0
	if overworld_people <= 0:
		end_game("Alle Bewohner der Oberwelt sind gestorben.", false)
	elif underworld_people <= 0:
		end_game("Alle Bewohner der Unterwelt sind gestorben.", false)
	
	# Lose: Irgendeine Mood = 100
	elif mood_overworld >= 100:
		end_game("Die Stimmung in der Oberwelt ist katastrophal.", false)
	elif mood_underworld >= 100:
		end_game("Die Stimmung in der Unterwelt ist katastrophal.", false)
	
	# Lose: Tag 14, beide Moods > 100
	elif daycounter >= 14 and combined_mood > 100:
		end_game("An Tag 14 ist die allgemeine Stimmung sehr schlecht.", false)
	
	# Win: Tag 14, beide Moods < 100
	elif daycounter >= 14 and combined_mood < 100:
		end_game("An Tag 14 konntet ihr beide Welten zufriedenstellen.", true)
	
	# Win: Beide Moods < 10 (egal wann)
	elif mood_overworld < 10 and mood_underworld < 10:
		end_game("Beide Welten sind sehr glücklich!", true)


func _on_resourcetimer_timeout() -> void:
	print("_on_clock")
	
	calculate_population()
	
	calculate_gold()
	
	hospital_tick()
	
	sickbay_tick()
	
	organic_tick()
	
	food_tick()
	
	chemical_tick()
	
	drug_tick()
	
	dump_tick()
	
	pollution_tick()
	
	pollution_infect_tick()
	
	consume()
	
	updateUI()
	check_end_conditions()

	pass # Replace with function body.
