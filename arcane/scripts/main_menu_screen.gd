extends Control


func _on_start_pressed():
	get_tree().change_scene_to_file("res://screens/mainScreen.tscn")
	pass # Replace with function body.


func _on_option_pressed():
	get_tree().change_scene_to_file("res://screens/optionsScreen.tscn")


func _on_how_to_pressed():
	get_tree().change_scene_to_file("res://screens/howToPlayScreen.tscn")


func _on_exit_pressed():
	get_tree().quit()
