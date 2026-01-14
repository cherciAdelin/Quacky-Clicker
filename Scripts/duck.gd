extends Node2D

## --------------- VARIABLES ---------------

## variables used for the duck accessories

@onready var weapon_sprite = $Weapon
@onready var hat_sprite = $Hat
@onready var speech_bubble := $SpeechBubble
@onready var speech_label := $SpeechBubble/Text


## variables used for the speaking logic of the duck

var text_speed := 0.03
var speech_bubble_on := false
signal duck_speaking(isTrue: bool)


## --------------- FUNCTIONS ---------------

## functon that sets the accessories to their default spirtes

func set_default_sprites():
	weapon_sprite.texture = null
	hat_sprite.texture = null


## function that writes text in the speech bubble and shows a character
## based on the speed set (currently every 0.1 seconds)
## it calls a function that makes the speech bubble appear on the screen and 
## after it's done talking, it either goes to the next line (if the chain variable is true)
## or closes the speech bubble

func speak(text: String, chain: bool):
	duck_speaking.emit(true)
	if(!speech_bubble_on):
		animate_speech_bubble(Vector2.ONE)
		speech_bubble_on = true
	speech_label.text = text
	speech_label.visible_characters = 0
	
	for i in text.length():
		speech_label.visible_characters = i + 1
		await get_tree().create_timer(text_speed).timeout
	
	await get_tree().create_timer(0.5).timeout
	
	duck_speaking.emit(false)
	if(!chain):
		animate_speech_bubble(Vector2.ZERO)
		speech_bubble_on = false

## function that makes the speech bubble either appear or disappear

func animate_speech_bubble(size: Vector2):
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(speech_bubble, "scale", size, 0.5)





## --------------- FUNCTIONS TRIGGERED BY SIGNALS ---------------

## function that triggers the moment you run the program
## it sets the accesories to their default sprites

func _ready():
	set_default_sprites()
	animate_speech_bubble(Vector2.ZERO)
	Global.duck = self


## functions that change the sprites of the hat/weapon whenever the main script sends a signal

func _on_duck_weapon_change(texture: Texture2D) -> void:
	weapon_sprite.texture = texture

func _on_duck_hat_change(texture: Texture2D) -> void:
	hat_sprite.texture = texture
