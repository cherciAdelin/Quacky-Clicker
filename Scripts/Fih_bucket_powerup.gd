extends "res://Scripts/powerup.gd"

var applied_multiplier := 1.0
signal multiplied_upgrades(active: bool, multiplier: float)

func apply_effect() -> void:
	applied_multiplier = 2 * Global.active_powerup_multiplier
	Global.click_value *= applied_multiplier
	multiplied_upgrades.emit(true, applied_multiplier)

func remove_effect() -> void:
	Global.click_value /= applied_multiplier
	multiplied_upgrades.emit(false, applied_multiplier)

func start_active_timer() -> void:
	activeTimer.start(Global.active_powerups["fih_bucket"]["duration"])

func start_cooldown_timer() -> void:
	var cooldown = Global.active_powerups["fih_bucket"]["cooldown"] - Global.active_powerup_cdr
	if(cooldown > 1):
		cooldownTimer.start(cooldown)
	else:
		cooldownTimer.start(1)
