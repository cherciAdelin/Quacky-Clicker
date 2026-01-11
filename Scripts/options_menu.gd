extends Control

signal optionsMenuExit
signal optionsMenuResume

func hide_menu():
	var opMenu := $"."
	opMenu.visible = false

func _on_resume_button_pressed() -> void:
	hide_menu()
	optionsMenuResume.emit()


func _on_exit_button_pressed() -> void:
	$VBoxContainer/ExitButton.disabled = true
	optionsMenuExit.emit()
	await get_tree().create_timer(1).timeout
	hide_menu()
	$VBoxContainer/ExitButton.disabled = false
