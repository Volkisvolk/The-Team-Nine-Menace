extends Node

@onready var tileMapLayer: TileMapLayer = $tileMapLayer
@onready var buildDialog: AcceptDialog = $buildDialog
var clickedTile

func _ready():
	var path = "Node2D/board/tileMapLayer"  # passe das ggf. an
	if has_node(path):
		tileMapLayer = get_node(path)
		print("TileMapLayer gefunden: ", tileMapLayer)
	else:
		print("TileMapLayer NICHT gefunden!")


# Hier Buildable Flächen geben, am besten sagen wir jewals arrays für gebäude und dann gebe nwir die gebäude da rein. Frag Volki

var buildable_tiles: Array[Vector2i] = [
	Vector2i(-5,11),
	Vector2i(-5,10),
	Vector2i(-5,9),
	Vector2i(-4,11),
	Vector2i(-4,10),
	Vector2i(-4,9),
	Vector2i(-3,11),
	Vector2i(-3,10),
	Vector2i(-3,9),	
]

func _unhandled_input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clickedTile = tileMapLayer.local_to_map(tileMapLayer.get_local_mouse_position())

		print(clickedTile)
		if clickedTile in buildable_tiles:
			open_build_dialog(clickedTile)

func open_build_dialog(tile: Vector2i) -> void:
	buildDialog.dialog_text = "Auf Feld " + str(clickedTile) + " bauen?"
	buildDialog.popup_centered()
