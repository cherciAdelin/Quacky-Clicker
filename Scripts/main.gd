extends Node2D

	## Variables

## variables that hold the score, damage-per-click, number of eggs broken
## the cost of the damage upgrades and the current upgrade dmg value
var points := 0.0
var click_value := 1.0
var eggs_broken := 0
var up_cost := 50
var up_val := 1.0

## first line creates the connection between this script and the egg script
## second line updates every value and label the moment you run the program
func _ready() -> void:
	$Egg.main = self
	update_ui()

	## Egg functions

## the signal you get from the egg collision shape when you click it
## it increases the "Currency" you have and also updates the UI
func _on_egg_egg_pressed() -> void:
	points += click_value
	update_ui()

## updates every label on-screen with the latest values
func update_ui():
	$UI/Score.text = "Current points: " + str(int(points))
	$UI/Click_val.text = "Click value: " + str(click_value)
	$UI/Upgrade1.text = "CLICK UPGRADE: " + str(up_cost) + " $$$"

## the signal you get when the egg health drops below 0
## it increases the number of eggs broken and provides a 20% bonus to your current points
func _on_egg_egg_broken() -> void:
	eggs_broken += 1
	points += int(points*0.2)
	$UI/Score.text = "Congratulations! You have broken " + str(eggs_broken) + " eggs! Bonus points awarded!"

	## Upgrade button functions

## the signal you get when you press the upgrade button
## it either tells you you don't have enough currency to upgrade or
## subtracts the upgrade cost from your current currency, increases the cost of the next upgrade
## increases the damage you deal to the egg and displays appropriate messages for each case
func _on_upgrade_1_pressed() -> void:
	if(points < up_cost):
		$UI/Upgrade1.text = "Insufficient currency!"
		await get_tree().create_timer(2.0).timeout
		update_ui()
	else:
		points -= up_cost
		up_cost += up_cost + 50
		up_clickval_flat()
		$UI/Upgrade1.text = "Upgrade succesful!"
		await get_tree().create_timer(2.0).timeout
		update_ui()

## increases the damage you deal to the egg and increases the next upgrade value by 0.1
func up_clickval_flat():
	click_value += up_val
	up_val += 0.1
	update_ui()
