extends Node

var currency := 100000.0
var eggsBroken := 0
var click_value := 1.0
var autoclick_value := 0.0

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
	
	"autoclick_up5":{
		"cost": 30000,
		"value": 50,
		"level": 0,
	}
}
