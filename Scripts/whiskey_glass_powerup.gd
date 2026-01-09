extends "res://Scripts/powerup.gd"

func apply_effect() -> void:
	Global.currency += int(Global.currency * 0.2)

func remove_effect() -> void:
	return

func start_active_timer() -> void:
	activeTimer.start(Global.active_powerups["whiskey_glass"]["duration"])

func start_cooldown_timer() -> void:
	var cooldown = Global.active_powerups["whiskey_glass"]["cooldown"] - Global.active_powerup_cdr
	if(cooldown > 1):
		cooldownTimer.start(cooldown)
	else:
		cooldownTimer.start(1)
