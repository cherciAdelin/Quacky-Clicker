## script inherits all the functions from the powerup.gd script
extends "res://Scripts/powerup.gd"

## --------------- VARIABLES ---------------

## variable used to remember the values of the upgrades before activating the 
## active powerup

var applied_multiplier := 1.0
signal multiplied_upgrades(active: bool, multiplier: float)


## --------------- FUNCTIONS ---------------

## this active powerup doubles the click power and sends a signal that makes it so
## for the duration of the active powerup, the click upgrades are doubled

func apply_effect() -> void:
	applied_multiplier = 2 * Global.active_powerup_multiplier
	Global.click_value *= applied_multiplier
	multiplied_upgrades.emit(true, applied_multiplier)

## this function removes the double click power and sends a signal that makes it so
## the click upgrades are no longer doubled

func remove_effect() -> void:
	Global.click_value /= applied_multiplier
	multiplied_upgrades.emit(false, applied_multiplier)


## function that starts the timer for the active duration of the powerup

func start_active_timer() -> void:
	activeTimer.start(Global.active_powerups["fih_bucket"]["duration"])


## function that starts the cooldown timer for the powerup
## it applies the cooldown reduction special stat and checks to see if the 
## cooldown reduction is more than the initial cooldown of the upgrade

func start_cooldown_timer() -> void:
	var cooldown = Global.active_powerups["fih_bucket"]["cooldown"] - Global.active_powerup_cdr
	if(cooldown > 1):
		cooldownTimer.start(cooldown)
	else:
		cooldownTimer.start(1)
