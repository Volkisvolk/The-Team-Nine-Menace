extends Node

@onready var floorLayer: TileMapLayer = $floorLayer
@onready var wallLayer: TileMapLayer = $wallLayer
@onready var buildingLayer: TileMapLayer = $buildingLayer
@onready var buildDialog: AcceptDialog = $"../buildDialog"
@onready var camera: Camera2D = $"../Camera2D"
var worldChangeBool = true # true equals Overworld

var clickedTile

func _ready():
	var path = "Node2D/board/floorLayer"  # passe das ggf. an
	if has_node(path):
		floorLayer = get_node(path)
		print("floorLayer gefunden: ", floorLayer)
	else:
		print("floorLayer NICHT gefunden!")


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
		clickedTile = floorLayer.local_to_map(floorLayer.get_local_mouse_position())
		print(clickedTile)
		if clickedTile in buildable_tiles:
			open_build_dialog(clickedTile)
			
			
	

func open_build_dialog(tile: Vector2i) -> void:
	buildDialog.dialog_text = "Auf Feld " + str(clickedTile) + " bauen?"
	buildDialog.popup_centered()


func _on_button_pressed() -> void:
	if worldChangeBool == true:
		for i in range(20):
			camera.position = Vector2(0,i*50)
			worldChangeBool = false
			await get_tree().create_timer(0.0000000000000001).timeout
		return
	if worldChangeBool == false:
		for i in range(20):
			var count = 1000 -i *50
			camera.position = Vector2(0.0,count)
			await get_tree().create_timer(0.0000000000000001).timeout
			worldChangeBool = true
		return
		
	pass # Replace with function body.
