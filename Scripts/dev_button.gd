extends Button

signal DevPress

func _on_pressed() -> void:
	Global.currency += 10000
	Global.total_currency += 10000
	DevPress.emit()
