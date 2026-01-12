extends Node

## --------------- VARIABLES ---------------

## this whole script is just for variables that hold
## key informations about the game

var currency := 10000000.0
var total_currency := 0.0
var eggshell_currency := 100000
var total_eggshell_currency := 0
var eggsBroken := 0
var special_lvl_limit := 10
var click_number := 0
var current_cursor_texture: Texture2D

var click_value := 1.0
var autoclick_value := 0.0

var eggshell_multiplier := 1.0
var eggshell_lower_limit := 1
var eggshell_upper_limit := 5
var active_powerup_cdr := 0.0
var active_powerup_multiplier := 1.0

## click and autoclick upgrades

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


## special upgrades

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

## active powerup details

var active_powerups := {
	
	"fih_bucket":{
		"cooldown": 300,
		"duration": 15,
	},
	
	"whiskey_glass":{
		"cooldown": 500,
		"duration": 0,
	},
	
	"cauldron":{
		"cooldown": 300,
		"duration": 30,
	},
	
	"elixir":{
		"cooldown": 500,
		"duration": 30,
	}
	
}

## quest details

var quests := {
	
	"quest1":{
		"condition": "Break 5 eggs!",
		"threshold": 5,
		"completed": false,
	},
	
	"quest2":{
		"condition": "Click the egg 1000 times!",
		"threshold": 1000,
		"completed": false,
	},
	
	"quest3":{
		"condition": "Get 10.000$!",
		"threshold": 10000,
		"completed": false,
	},
	
	"quest4":{
		"condition": "Get 5.000 eggshells!",
		"threshold": 5000,
		"completed": false,
	},
	
	"quest5":{
		"condition": "Reach 100 click power!",
		"threshold": 100,
		"completed": false,
	},
	
	"quest6":{
		"condition": "Reach 100 duck click power!",
		"threshold": 100,
		"completed": false,
	}
}
