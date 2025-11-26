extends Node

## global variables for easy access in all the other scripts
var currency := 1000.0
var eggsBroken := 0
var click_value := 1.0

## dictionary that holds the information about all the upgrades in the upgrade menu
var upgrades = {
	
	"click_up":{
		"cost": 100,
		"value": 1.0,
		"level": 0,
	},
	
	"autoclicker":{
		"cost": 1000,
		"value": 0.0,
		"level": 0,
	}
	
}
