extends Node

var currency := 100000.0
var eggshell_currency := 0
var eggsBroken := 0

var click_value := 1.0
var autoclick_value := 0.0

var eggs_broken_multiplier := 1.0
var eggshell_multiplier := 1.0
var eggshell_lower_limit := 1
var eggshell_upper_limit := 5
var active_powerup_cooldown := 300.0
var active_powerup_multiplier := 1.0

var upgrades = {
	
	"click_up":{
		"cost": 100,
		"value": 1.0,
		"level": 0,
	},
	
	"click_up2":{
		"cost": 1000,
		"value": 15,
		"level": 0	
	},
	
	"click_up3":{
		"cost": 5000,
		"value": 25,
		"level": 0	
	},
	
	"click_up4":{
		"cost": 10000,
		"value": 50,
		"level": 0
	},
	
	"click_up5":{
		"cost": 15000,
		"value": 70,
		"level": 0	
	},
	
	"autoclick_up1":{
		"cost": 1000,
		"value": 1.0,
		"level": 0,
	},
	
	"autoclick_up2":{
		"cost": 5000,
		"value": 5.0,
		"level": 0,
	},
	
	"autoclick_up3":{
		"cost":10000,
		"value": 10.0,
		"level": 0,
	},
	
	"autoclick_up4":{
		"cost": 15000,
		"value": 20,
		"level": 0,
	},
}

var hats = {
	
	"straw_hat":{
		"cost": 15,
		"value": 1.0,
		"level": 0,
	},
	
	"cowboy_hat":{
		"cost": 30,
		"value": 1.0,
		"level": 0,
	},
	
	"witch_hat":{
		"cost": 45,
		"value": 1.0,
		"level": 0,
	},
	
	"wizard_hat":{
		"cost": 60,
		"value": 1.0,
		"level": 0,
	}
	
}
