extends Button

var worldChangeBool := true  # Start in Overworld
@onready var root : Node2D = get_tree().current_scene
@onready var camera : Camera2D = $"../../../../Camera2D"
@onready var gradient_bar = $GradientBar
@onready var overworld_pointer = $OverworldPointer
@onready var underworld_pointer = $UnderworldPointer
@onready var mood_cover = $MoodCover
@onready var cover_label = $MoodCover/CoverLabel
@onready var animation_player = $AnimationPlayer

var toload = true

func _ready():
	update_mood_pointer()

func _process(delta):
	if toload:
		update_mood_pointer()
		toload = false

func _on_button_pressed() -> void:
	if worldChangeBool:
		camera.position = Vector2(0, 972)
		worldChangeBool = false
	else:
		camera.position = Vector2(0.0, 0.0)
		worldChangeBool = true

	update_mood_pointer()

func update_mood_pointer():
	var mood_range := 100.0
	var bar_width = gradient_bar.size.x
	var center = bar_width / 2.0

	var mood: int = root.mood_overworld if worldChangeBool else root.mood_underworld
	var ratio = clamp(mood / mood_range, 0.0, 1.0)
	var offset = ratio * center

	overworld_pointer.visible = worldChangeBool
	underworld_pointer.visible = not worldChangeBool

	if worldChangeBool:
		overworld_pointer.position.x = center - offset - (overworld_pointer.size.x / 2.0)
	else:
		underworld_pointer.position.x = center + offset - (underworld_pointer.size.x / 2.0)

	cover_label.text = "Underworld" if worldChangeBool else "Overworld"

	if worldChangeBool:
		animation_player.play("slide_right")
	else:
		animation_player.play("slide_left")
