extends Control

signal StartPressed
@onready var door = $Door

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_start_button_pressed() -> void:
	open_door()
	await get_tree().create_timer(0.1).timeout
	StartPressed.emit()

func open_door():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	door.scale = Vector2(1, 1)
	tween.tween_property(door, "scale:x", 0.1, 0.4)
	
	await get_tree().create_timer(3).timeout
	var tween2 = create_tween()
	tween2.tween_property(door, "scale:x", 1, 0.1)
