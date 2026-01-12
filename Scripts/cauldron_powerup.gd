## script inherits all the functions from the powerup.gd script
extends "res://Scripts/powerup.gd"

## --------------- VARIABLES ---------------

## variables used to remember the values of the upgrades before activating the 
## active powerup

var lower_shells: int
var upper_shells: int


## --------------- FUNCTIONS ---------------

## this active powerup maxes out the eggshells gained for a set amount of time
## it first saves the initial limits of the eggshell gains then raises the 
## lower limit to the upper limit so you'll always get the maximum value for that time

func apply_effect() -> void:
	lower_shells = Global.eggshell_lower_limit
	upper_shells = Global.eggshell_upper_limit
	Global.eggshell_lower_limit = Global.eggshell_upper_limit


## function that removes the effect of the powerup
## it sets the lower limit to its previous value then adds the 
## difference between the current upper limit and the old upper limit 
## in case the upper limit has changed while the upgrade was active

func remove_effect() -> void:
	Global.eggshell_lower_limit = lower_shells + (Global.eggshell_upper_limit - upper_shells)


## function that starts the active timer of the powerup

func start_active_timer() -> void:
	activeTimer.start(Global.active_powerups["cauldron"]["duration"])


## function that starts the cooldown timer of the powerup
## it applies the cooldown reduction special stat and checks to see if the 
## cooldown reduction is more than the initial cooldown of the upgrade

func start_cooldown_timer() -> void:
	var cooldown = Global.active_powerups["cauldron"]["cooldown"] - Global.active_powerup_cdr
	if(cooldown > 1):
		cooldownTimer.start(cooldown)
	else:
		cooldownTimer.start(1)
