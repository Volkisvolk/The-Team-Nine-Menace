extends Button

var worldChangeBool := true  # Start in Overworld
@onready var root : Node2D = get_tree().current_scene
@onready var camera : Camera2D =$"../../../../../Camera2D"
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
		#camera.position = Vector2(0, 972)
		camera.get_node("AnimationPlayer").play("toUnder")
		worldChangeBool = false
	else:
		#camera.position = Vector2(0.0, 0.0)
		camera.get_node("AnimationPlayer").play("toOver")
		worldChangeBool = true

	update_mood_pointer()

func update_mood_pointer():
	var mood_range := 100.0
	var bar_width = $GradientBar.get_rect().size.x
	var bar_center_x = bar_width / 2.0

	var mood: int = root.mood_overworld if worldChangeBool else root.mood_underworld
	var ratio = clamp(mood / mood_range, 0.0, 1.0)
	var offset = ratio * (bar_width / 2.0)

	$GradientBar/OverworldPointer.visible = worldChangeBool
	$GradientBar/UnderworldPointer.visible = not worldChangeBool

	if worldChangeBool:
		$GradientBar/OverworldPointer.position.x = bar_center_x - offset - ($GradientBar/OverworldPointer.size.x / 2.0)
	else:
		$GradientBar/UnderworldPointer.position.x = bar_center_x + offset - ($GradientBar/UnderworldPointer.size.x / 2.0)

	$MoodCover/CoverLabel.text = "Underworld" if worldChangeBool else "Overworld"

	if worldChangeBool:
		$AnimationPlayer.play("slide_right")
	else:
		$AnimationPlayer.play("slide_left")
