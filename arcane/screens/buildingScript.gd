extends Node

@onready var floorLayer: TileMapLayer = $floorLayer
@onready var wallLayer: TileMapLayer = $wallLayer
@onready var buildingLayer: TileMapLayer = $buildingLayer
@onready var buildDialog: AcceptDialog = $"../buildDialog"
@onready var buildInfoDialog: AcceptDialog = $"../buildInfoDialog"
@onready var levelLabel: Label = $"../buildInfoDialog/VBoxContainer/levelLabel"
@onready var camera: Camera2D = $"../Camera2D"

var selected_building_type: String = ""
var worldChangeBool = true
var clickedTile: Vector2i

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

		for gebaeude_typ in buildable_tiles.keys():
			var data = buildable_tiles[gebaeude_typ]

			# Suche das zugehörige Zentrum
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
					return  # sobald ein Zentrum gefunden wurde, abbrechen


func open_build_dialog(center: Vector2i, gebaeude_typ: String) -> void:
	clickedTile = center  # Zentrum merken
	buildDialog.dialog_text = "Auf 3x3-Feld um " + str(center) + " ein " + gebaeude_typ.capitalize() + " bauen?"
	buildDialog.popup_centered()


func _on_build_dialog_confirmed():
	if selected_building_type in buildable_tiles:
		var data = buildable_tiles[selected_building_type]
		var area = get_3x3_area(clickedTile)

		var area_is_free := true
		for pos in area:
			if pos in data["built_tiles"]:
				area_is_free = false
				break

		if area_is_free:
			for pos in area:
				buildingLayer.set_cell(pos, 0, Vector2i(6, 6))  # Beispiel-Kachel
				data["built_tiles"].append(pos)
			data["levels"][clickedTile] = 1
			show_build_info(selected_building_type, clickedTile)
		else:
			print("Ein Teil des 3x3-Felds ist schon bebaut.")
	else:
		print("Unbekannter Gebäudetyp:", selected_building_type)

func show_build_info(gebaeude_typ: String, tile: Vector2i) -> void:
	if gebaeude_typ in buildable_tiles:
		var data = buildable_tiles[gebaeude_typ]
		var level = data["levels"].get(tile, 1)
		levelLabel.text = "Level: " + str(level)
		buildInfoDialog.popup_centered()
	else:
		print("Fehler: Gebäudetyp nicht bekannt für Info-Popup:", gebaeude_typ)

func _on_upgrade_button_pressed():
	if selected_building_type in buildable_tiles:
		var data = buildable_tiles[selected_building_type]
		if clickedTile in data["levels"]:
			data["levels"][clickedTile] += 1
			levelLabel.text = "Level: " + str(data["levels"][clickedTile])
		else:
			print("Kein Level-Eintrag für:", clickedTile)

func _on_button_pressed() -> void:
	if worldChangeBool:
		camera.position = Vector2(0,972)
		worldChangeBool = false
	else:
		camera.position = Vector2(0.0,0.0)
		worldChangeBool = true
		return
	pass # Replace with function body.
