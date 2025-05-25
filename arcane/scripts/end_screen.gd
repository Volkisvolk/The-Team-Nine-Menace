extends CanvasLayer

@onready var reason_label: Label = $VBoxContainer/ReasonLabel
@onready var main_menu_button: Button = $VBoxContainer/MainMenuButton

func _ready():
	main_menu_button.pressed.connect(func():
		get_tree().change_scene_to_file("res://screens/mainMenuScreen.tscn")
	)

func show_end(reason: String, is_win: bool):
	print("Endscreen anzeigen mit Text:", reason)

	$VBoxContainer/ReasonLabel.text = reason
	if is_win:
		$VBoxContainer/Label.text = "YOU WIN!"
	else:
		$VBoxContainer/Label.text = "GAME OVER"

	self.visible = true
