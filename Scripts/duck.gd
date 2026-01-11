extends Node2D

@onready var weapon_sprite = $Weapon
@onready var hat_sprite = $Hat

func _on_duck_weapon_change(texture: Texture2D) -> void:
	weapon_sprite.texture = texture

func _on_duck_hat_change(texture: Texture2D) -> void:
	hat_sprite.texture = texture
