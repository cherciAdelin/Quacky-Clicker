extends "res://Scripts/powerup.gd"

func apply_effect() -> void:
	pass

func remove_effect() -> void:
	pass

func start_active_timer() -> void:
	activeTimer.start(Global.active_powerups["elixir"]["duration"])

func start_cooldown_timer() -> void:
	var cooldown = Global.active_powerups["elixir"]["cooldown"] - Global.active_powerup_cdr
	if(cooldown > 1):
		cooldownTimer.start(cooldown)
	else:
		cooldownTimer.start(1)
