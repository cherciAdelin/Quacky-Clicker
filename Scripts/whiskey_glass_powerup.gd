## script inherits all the functions from the powerup.gd script
extends "res://Scripts/powerup.gd"

## --------------- FUNCTIONS ---------------

## function that gives a 20% boost to the currency

func apply_effect() -> void:
	var inc_val := int(Global.currency * 0.2)
	Global.currency += inc_val
	Global.total_currency += inc_val


## function that does nothing since the active powerup gives an instant 
## one time boost

func remove_effect() -> void:
	return


## function that starts the active timer of the powerup

func start_active_timer() -> void:
	activeTimer.start(Global.active_powerups["whiskey_glass"]["duration"])


## function that starts the cooldown timer of the powerup
## it applies the cooldown reduction special stat and checks to see if the 
## cooldown reduction is more than the initial cooldown of the upgrade


func start_cooldown_timer() -> void:
	var cooldown = Global.active_powerups["whiskey_glass"]["cooldown"] - Global.active_powerup_cdr
	if(cooldown > 1):
		cooldownTimer.start(cooldown)
	else:
		cooldownTimer.start(1)
