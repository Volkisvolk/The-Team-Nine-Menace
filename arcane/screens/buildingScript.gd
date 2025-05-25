extends Node

@onready var floorLayer: TileMapLayer = $floorLayer
@onready var wallLayer: TileMapLayer = $wallLayer
@onready var buildingLayer: TileMapLayer = $buildingLayer
@onready var buildDialog: AcceptDialog = $"../buildDialog"
@onready var buildInfoDialog: AcceptDialog = $"../buildInfoDialog"
@onready var levelLabel: Label = $"../buildInfoDialog/VBoxContainer/levelLabel"
@onready var upgradeCostLabel: Label = $"../buildInfoDialog/VBoxContainer/upgradeCost"
@onready var rootNode: Node2D = $"../.."

signal upgrade_building

var selected_building_type: String = ""
var clickedTile: Vector2i
var current_center_tile: Vector2i  # Zentrum des aktiven Gebäudes für Info & Upgrade


func _ready():
	var path = "Node2D/board/floorLayer"
	if has_node(path):
		floorLayer = get_node(path)
		print("floorLayer gefunden: ", floorLayer)
	else:
		print("floorLayer NICHT gefunden!")
		
	

func get_3x3_area(center: Vector2i) -> Array[Vector2i]:
	var area: Array[Vector2i] = []
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			area.append(center + Vector2i(dx, dy))
	return area


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clickedTile = floorLayer.local_to_map(floorLayer.get_local_mouse_position())
		print("Geklicktes Tile: ", clickedTile)

		for gebaeude_typ in rootNode.buildable_tiles.keys():
			var data = rootNode.buildable_tiles[gebaeude_typ]

			for center in data["centers"]:
				var area = get_3x3_area(center)
				if clickedTile in area:
					selected_building_type = gebaeude_typ

					if center in data["levels"]:
						show_build_info(gebaeude_typ, center)
					else:
						var area_is_free := true
						for pos in area:
							if pos in data["built_tiles"]:
								area_is_free = false
								break
						if area_is_free:
							open_build_dialog(center, gebaeude_typ)
						else:
							print("Ein Teil des 3x3-Felds ist schon bebaut.")
					return


func open_build_dialog(center: Vector2i, gebaeude_typ: String) -> void:
	clickedTile = center
	buildDialog.dialog_text = "Auf 3x3-Feld um " + str(center) + " ein " + gebaeude_typ.capitalize() + " bauen?"
	buildDialog.popup_centered()


func _on_build_dialog_confirmed():
	if selected_building_type in rootNode.buildable_tiles:
		var data = rootNode.buildable_tiles[selected_building_type]
		var area = get_3x3_area(clickedTile)

		var area_is_free := true
		for pos in area:
			if pos in data["built_tiles"]:
				area_is_free = false
				break

		if area_is_free:
			for pos in area:
				data["built_tiles"].append(pos)
				# Nur das Zentrum bekommt eine sichtbare Kachel
				if pos == clickedTile:
					if selected_building_type == "Farm":
						buildingLayer.set_cell(pos, 1, Vector2i(1, 0))  # Apartment-Zentrum
					elif selected_building_type == "Butcher":
						buildingLayer.set_cell(pos, 1, Vector2i(3, 0))  # Standard-Zentrum
					elif selected_building_type == "Hospital":
						buildingLayer.set_cell(pos, 1, Vector2i(7, 0))
					elif selected_building_type == "Sickbay":
						buildingLayer.set_cell(pos, 1, Vector2i(7, 0))  # Standard-Zentrum
					elif selected_building_type == "Apartment":
						buildingLayer.set_cell(pos, 6, Vector2i(0, 0)) 
					elif selected_building_type == "Hut":
						buildingLayer.set_cell(pos, 7, Vector2i(0, 0)) 
					elif selected_building_type == "Mine":
						buildingLayer.set_cell(pos, 12, Vector2i(0, 0)) 
					elif selected_building_type == "Lab":
						buildingLayer.set_cell(pos, 9, Vector2i(0, 0)) 
					elif selected_building_type == "Dump":
						buildingLayer.set_cell(pos, 8, Vector2i(0, 0)) 
					elif selected_building_type == "Overworld":
						buildingLayer.set_cell(pos, 15, Vector2i(0, 0)) 
					elif selected_building_type == "Underworld":
						buildingLayer.set_cell(pos, 16, Vector2i(0, 0)) 
						

			data["levels"][clickedTile] = rootNode.startLevel + 1
			rootNode.spend_gold(data["upgradeCosts"][0])
			
			if selected_building_type == "Hut":
				rootNode.underworld_people_max += 5
			if selected_building_type == "Apartment":
				rootNode.overworld_people_max += 5
		else:
			print("Ein Teil des 3x3-Felds ist schon bebaut.")
	else:
		print("Unbekannter Gebäudetyp:", selected_building_type)


func show_build_info(gebaeude_typ: String, tile: Vector2i) -> void:
	current_center_tile = tile  # Wichtig für Upgrade

	if gebaeude_typ in rootNode.buildable_tiles:
		var data = rootNode.buildable_tiles[gebaeude_typ]
		var level = data["levels"].get(tile, 1)
		levelLabel.text = "Level: " + str(level)
		#TODO: Placeholder
		upgradeCostLabel.text = "Upgrade-Kosten: " + str(data["upgradeCosts"][level]) + " Gold"
		buildInfoDialog.popup_centered()
	else:
		print("Fehler: Gebäudetyp nicht bekannt für Info-Popup:", gebaeude_typ)


func _on_upgrade_button_pressed():
	if selected_building_type in rootNode.buildable_tiles:
		var data = rootNode.buildable_tiles[selected_building_type]

		if current_center_tile in data["levels"]:
			var level = data["levels"].get(current_center_tile, 1)

			if level == 5:
				print("Can't upgrade – already max level.")
				return

			var cost = data["upgradeCosts"][level]
			if rootNode.gold >= cost:
				rootNode.spend_gold(cost)
				var new_level = level + 1
				data["levels"][current_center_tile] = new_level

				levelLabel.text = "Level: " + str(new_level)
				emit_signal("upgrade_building", selected_building_type, new_level)

				# Grafik für das Zentrum anpassen je nach Typ und Level
				match selected_building_type:
					"Farm":
						match new_level:
							3: buildingLayer.set_cell(current_center_tile, 1, Vector2i(1, 0))
							5: buildingLayer.set_cell(current_center_tile, 1, Vector2i(2, 0))
					"Butcher":
						match new_level:
							3: buildingLayer.set_cell(current_center_tile, 1, Vector2i(4, 0))
							5: buildingLayer.set_cell(current_center_tile, 1, Vector2i(5, 0))
					"Mine":
						match new_level:
							3: buildingLayer.set_cell(current_center_tile, 13, Vector2i(0, 0))
							5: buildingLayer.set_cell(current_center_tile, 14, Vector2i(0, 0))
					"Lab":
						match new_level:
							3: buildingLayer.set_cell(current_center_tile, 10, Vector2i(0, 0))
							5: buildingLayer.set_cell(current_center_tile, 11, Vector2i(0, 0))
					# Optional: weitere Gebäudetypen ergänzen, falls dort ebenfalls Upgrades sichtbar werden sollen

				buildInfoDialog.hide()
			else:
				print("Nicht genug Gold.")
		else:
			print("Kein Level-Eintrag für:", current_center_tile)
