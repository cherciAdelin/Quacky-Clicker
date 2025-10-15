extends Node2D

var points := 0
var click_value := 10
var eggs_broken := 0

func _ready() -> void:
	#DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	$Egg.main = self
	update_ui()

func _on_egg_egg_pressed() -> void:
	points += click_value
	update_ui()

func update_ui():
	$UI/Score.text = "Current points: " + str(points)

func _on_egg_egg_broken() -> void:
	eggs_broken += 1
	points += int(points*0.1)
	$UI/Score.text = "Congratulations! You have broken " + str(eggs_broken) + " eggs! Bonus points awarded!"
