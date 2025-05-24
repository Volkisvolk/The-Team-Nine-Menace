extends Node2D

@onready var day_hand: Sprite2D = $ClockHand
@onready var day_label: Label = $DateLabel
@onready var update_timer: Timer = $UpdateTimer
@onready var day_timer: Timer = $DayTimer
signal three_day_event
var time_passed := 0.0
var current_day := 1

func _ready():
	update_timer.wait_time = 0.1
	update_timer.timeout.connect(_on_update_timer_tick)
	update_timer.start()

	day_timer.wait_time = 60.0
	day_timer.timeout.connect(_on_day_timer_timeout)
	day_timer.start()

	_update_ui()

func _on_update_timer_tick():
	time_passed += update_timer.wait_time
	if time_passed > 60.0:
		time_passed = 0.0  # oder hier auf 0 setzen, falls du keinen Drift willst
	_update_ui()

func _on_day_timer_timeout():
	current_day += 1
	if current_day % 3 == 0:
		emit_signal("three_day_event")
	time_passed = 0.0  # resette sicherheitshalber
	_update_ui()

func _update_ui():
	day_hand.rotation_degrees = time_passed * 6.0 
	day_label.text = "Tag %d" % current_day
