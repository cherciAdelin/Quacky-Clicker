extends OptionButton

## --------------- VARIABLES ---------------

@onready var windowMode := $"."


## array that holds window modes

var windowModeOptions := [
	"Full-Screen",
	"Windows Mode",
	"Borderless Window",
	"Borderless Full-Screen"
]


## --------------- FUNCTIONS TRIGGERED BY SIGNALS ---------------

## function that triggers the moment you run the program
## it initializes all the window modes in the "options" button 

func _ready():
	for mode in windowModeOptions:
		windowMode.add_item(mode)
	windowMode.item_selected.connect(_on_window_mode_selected)


## function that triggers when you change the window mode in the "options" button
## it changes the window mode 

func _on_window_mode_selected(index: int):
	match index:
		0: #fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: #windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: #borderless windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: #borderless fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
