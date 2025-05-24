extends Node

@onready var floorLayer: TileMapLayer = $floorLayer
@onready var wallLayer: TileMapLayer = $wallLayer
@onready var buildingLayer: TileMapLayer = $buildingLayer
@onready var buildDialog: AcceptDialog = $"../buildDialog"
@onready var camera: Camera2D = $"../Camera2D"

var selected_building_type: String = ""
var worldChangeBool = true # true equals Overworld
var clickedTile: Vector2i

# Dictionary mit buildbaren Tiles pro Gebäudetyp
var buildable_tiles := {
	"Apartment": {
		"positions": [
			Vector2i(-5,11), Vector2i(-5,10), Vector2i(-5,9),
			Vector2i(-4,11), Vector2i(-4,10), Vector2i(-4,9),
			Vector2i(-3,11), Vector2i(-3,10), Vector2i(-3,9)
		],
		"build": false
	},
	"haus": {
		"positions": [
			Vector2i(-3,5), Vector2i(-4,5), Vector2i(-5,5),
			Vector2i(-3,6), Vector2i(-4,6), Vector2i(-5,6),
			Vector2i(-3,7), Vector2i(-4,7), Vector2i(-5,7)
		],
		"build": false
	},
}


func _ready():
	var path = "Node2D/board/floorLayer"  
	if has_node(path):
		floorLayer = get_node(path)
		print("floorLayer gefunden: ", floorLayer)
	else:
		print("floorLayer NICHT gefunden!")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clickedTile = floorLayer.local_to_map(floorLayer.get_local_mouse_position())
		print("Geklicktes Tile: ", clickedTile)

		for gebaeude_typ in buildable_tiles.keys():
			var data = buildable_tiles[gebaeude_typ]
			if clickedTile in data["positions"]:
				open_build_dialog(clickedTile, gebaeude_typ)
				break


func open_build_dialog(tile: Vector2i, gebaeude_typ: String) -> void:
	if gebaeude_typ in buildable_tiles:
		var data = buildable_tiles[gebaeude_typ]

		if data.has("build") and data["build"] == false:
			selected_building_type = gebaeude_typ
			buildDialog.dialog_text = "Auf Feld ein " + gebaeude_typ.capitalize() + " bauen?"
			buildDialog.popup_centered()
		else:
			print("Gebäude wurde bereits gebaut:", gebaeude_typ)
	else:
		print("Unbekannter Gebäudetyp:", gebaeude_typ)


func _on_build_dialog_confirmed():
	print("OK gedrückt für: ", selected_building_type)

	if selected_building_type in buildable_tiles:
		var data = buildable_tiles[selected_building_type]

		if data.has("build") and data["build"] == false:
			for tile_pos in data["positions"]:
				buildingLayer.set_cell(tile_pos, 0, Vector2i(6, 6))  # Beispielkoordinate
			buildable_tiles[selected_building_type]["build"] = true  # markieren als gebaut
			print(selected_building_type, " wurde gebaut.")
		else:
			print("Bauen nicht erlaubt für:", selected_building_type)
	else:
		print("Unbekannter Gebäudetyp:", selected_building_type)


func _on_button_pressed() -> void:
	if worldChangeBool == true:
		for i in range(20):
			camera.position = Vector2(0, i * 50)
			worldChangeBool = false
			await get_tree().create_timer(0.0000000000000001).timeout
		return
	else:
		for i in range(20):
			var count = 1000 - i * 50
			camera.position = Vector2(0.0, count)
			await get_tree().create_timer(0.0000000000000001).timeout
			worldChangeBool = true
		return
