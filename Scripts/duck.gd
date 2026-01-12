extends Node2D

## --------------- VARIABLES ---------------

## variables used for the duck accessories

@onready var weapon_sprite = $Weapon
@onready var hat_sprite = $Hat


## --------------- FUNCTIONS TRIGGERED BY SIGNALS ---------------

## functions that change the sprites of the hat/weapon whenever the main script sends a signal

func _on_duck_weapon_change(texture: Texture2D) -> void:
	weapon_sprite.texture = texture

func _on_duck_hat_change(texture: Texture2D) -> void:
	hat_sprite.texture = texture
