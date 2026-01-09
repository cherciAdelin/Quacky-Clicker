extends "res://Scripts/powerup.gd"

var lower_shells: int
var upper_shells: int

func apply_effect() -> void:
	lower_shells = Global.eggshell_lower_limit
	upper_shells = Global.eggshell_upper_limit
	Global.eggshell_lower_limit = Global.eggshell_upper_limit

func remove_effect() -> void:
	Global.eggshell_lower_limit = lower_shells + (Global.eggshell_upper_limit - upper_shells)

func start_active_timer() -> void:
	activeTimer.start(Global.active_powerups["cauldron"]["duration"])

func start_cooldown_timer() -> void:
	var cooldown = Global.active_powerups["cauldron"]["cooldown"] - Global.active_powerup_cdr
	if(cooldown > 1):
		cooldownTimer.start(cooldown)
	else:
		cooldownTimer.start(1)
