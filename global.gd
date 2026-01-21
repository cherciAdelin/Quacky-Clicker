extends Node

## --------------- VARIABLES ---------------

## this whole script is just for variables that hold
## key informations about the game and a function that 
## resets them for when you prestige the game

var currency: float
var total_currency: float
var default_currency := 0.0
var eggshell_currency: int
var total_eggshell_currency: int
var default_eggshell_currency := 0
var eggsBroken: int
var default_eggsBroken := 0
var special_lvl_limit: int
var default_special_lvl_limit := 10
var click_number: int
var default_click_number := 0
var current_cursor_texture := preload("res://Assets/Sprites/CursorSprites/default_cursor.png")
var default_cursor_texture := preload("res://Assets/Sprites/CursorSprites/default_cursor.png")

var click_value: float
var default_click_value := 1.0
var autoclick_value: float
var default_autoclick_value := 0.0

var eggshell_multiplier: float
var default_eggshell_multiplier := 1.0
var eggshell_lower_limit: int
var eggshell_upper_limit: int
var default_eggshell_lower_limit := 1
var default_eggshell_upper_limit := 10
var active_powerup_cdr: float
var active_powerup_multiplier: float
var default_active_powerup_cdr := 0.0
var default_active_powerup_multiplier := 1.0


## variables used for global access to the duck scene

var duck
var main_menu_tutorial_dialogue_seen = false
var egg_tutorial_dialogue_seen = false

## click and autoclick upgrades

var upgrades = {
	
	"click_up":{
		"cost": 50,
		"value": 2,
		"level": 0,
	},
	
	"click_up2":{
		"cost": 250,
		"value": 5,
		"level": 0	
	},
	
	"click_up3":{
		"cost": 750,
		"value": 15,
		"level": 0	
	},
	
	"click_up4":{
		"cost": 1500,
		"value": 50,
		"level": 0
	},
	
	"click_up5":{
		"cost": 3500,
		"value": 100,
		"level": 0	
	},
	
	"autoclick_up1":{
		"cost": 250,
		"value": 1,
		"level": 0,
	},
	
	"autoclick_up2":{
		"cost": 1000,
		"value": 5,
		"level": 0,
	},
	
	"autoclick_up3":{
		"cost": 3000,
		"value": 25,
		"level": 0,
	},
	
	"autoclick_up4":{
		"cost": 7000,
		"value": 70,
		"level": 0,
	},
}


## special upgrades

var hats = {
	
	"straw_hat":{
		"cost": 150,
		"value": 1.0,
		"level": 0,
	},
	
	"cowboy_hat":{
		"cost": 300,
		"value": 1.0,
		"level": 0,
	},
	
	"witch_hat":{
		"cost": 450,
		"value": 1.0,
		"level": 0,
	},
	
	"wizard_hat":{
		"cost": 600,
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
		"condition": "Break 100 eggs!",
		"threshold": 100,
		"completed": false,
	},
	
	"quest2":{
		"condition": "Click the egg 10000 times!",
		"threshold": 10000,
		"completed": false,
	},
	
	"quest3":{
		"condition": "Get 100.000$!",
		"threshold": 100000,
		"completed": false,
	},
	
	"quest4":{
		"condition": "Get 45.000 eggshells!",
		"threshold": 45000,
		"completed": false,
	},
	
	"quest5":{
		"condition": "Reach 2500 click power!",
		"threshold": 2500,
		"completed": false,
	},
	
	"quest6":{
		"condition": "Reach 2500 duck click power!",
		"threshold": 2500,
		"completed": false,
	}
}


var text_monologue := {
	
	## first two lines are called at the beginning of the game when you first 
	## press "start" in the main menu
	## they're called in the mainMenu.gd script
	
	##the 3rd line is called when you reach the amount required for the first
	## click upgrade
	## the speak function is called in the egg.gd script
	
	"Tutorial": {
		1: "  Greetings! Welcome to QuackyClicker, a game about.... clicking.... very original...",
		2: "   Why don't you try hitting that suspiciously large egg?",
		3: "   Great! You have enough money for your first upgrade! Go ahead and open the menu that resembles a cursor in the bottom left.",
		4: "   You just unlocked something AMAZING... go ahead and click the button that has a duck on it...",
	},
	
	
	## the first one is called when you buy the first click upgrade for the first time
	## the rest are called when you unlock them
	## the speak function is called in the upgrade_menu.gd script
	
	"Click_up_menu":{
		1: "   There you go, now you don't have to use your finger to hit that guy...",
		2: "   Hey look you just unlocked a new click upgrade. Go ahead, buy it, who cares about your kid's college funds...",
		3: "   Isn't that Thor's hamm- nevermind.... you just unlocked a new click upgrade!",
		4: "   Hey, take a break you animal.... you just unlocked one of my favourite tools.... come on, make your neighbours happy... ",
		5: "   Congratulations! You've just unlocked a weapon of mass destruction! Can't wait to see how you'll use it... "
	},
	
	
	## the odd keys are called when you buy an autoclick upgrade for the first time and the even keys are
	## called when you buy a special upgrade for the first time
	## the speak function is called by the autoclick_up_menu.gd script
	
	"Autoclick_up_menu":{
		1: "   Yay, isn't this wonderful? You unlocked a menu JUST FOR ME! Now i can help you murder the egg!",
		2: "   Oh cool my first complete outfit, thank you. By the way, whenever you unlock both the weapon and the hat from a set, you'll also get an active powerup. This one doubles your click power!",
		3: "   Damn, I kinda feel bad for the egg... I mean imagine chilling in ur spherical residence and someone starts shooting your walls for no reason...",
		4: "   This one looks expensive. LOOK you just got a BRAND NEW active powerup. This one'll give you 20% of your current currency INSTANTLY!",
		5: "   You know... I can fly on my own, I don't really need this... thanks either way...",
		6: "   Great... that's exactly what was missing from my Halloween outfit... don't forget about your active powerup... this one maxes out your eggshell gain!",
		7: "   Don't you have like... a sword or something... you know... something a little more masculine...",
		8: "   I can feel Gandalf coming inside me now that his accessories are all mine! The next active powerup doubles MY power",
	},
	
	"Quest":{
		
		## microwave
		1: "   You might wanna check that quest tab... maybe there's something for you... ",
		2: "   Cool, finally something usef- What do you mean it doesn't work... So we're just getting junk as rewards now...",
		## plant
		3: "   This place could really use a plant or something gree-.... THERE'S NO WAY... Check the quest menu...",
		4: "   Simply beautiful...",
		## painting 1
		5:"   Ooh I wonder what the Gods have prepared for us this time... Check quests...", 
		6: "   Who the f**k is this lady bro... Can't you throw it in a pool full of sharks... It's creeping me tf out...",
		## cat
		7: "   I think you're gonna love this one! Check the quest menu real quick...",
		8:  "   JUST LOOK AT HER Cutest thing on the planet...",
		## painting 2
		9: "   Hey, look, another useless thing just for us... Check quests...",
		10: "   OH MY GOD... I apologize for my previous comment... This is the best one so far...",
		## painting 3
		11: "   Hope you're ready for this one man... Check quests",
		12: "   Congrats dude, now you're officially Forklift Certified... Although it might be expired... holy f**k it says 2001"
	},
	
}



## --------------- FUNCTIONS ---------------

## function that sets every global variable to their default values

func set_global_variables_default():
	currency = default_currency
	total_currency = default_currency
	eggshell_currency = default_eggshell_currency
	total_eggshell_currency = default_eggshell_currency
	eggsBroken = default_eggsBroken
	special_lvl_limit = default_special_lvl_limit
	click_number = default_click_number
	click_value = default_click_value
	autoclick_value = default_autoclick_value
	eggshell_multiplier = default_eggshell_multiplier
	eggshell_lower_limit = default_eggshell_lower_limit
	eggshell_upper_limit = default_eggshell_upper_limit
	active_powerup_cdr = default_active_powerup_cdr
	active_powerup_multiplier = default_active_powerup_multiplier
