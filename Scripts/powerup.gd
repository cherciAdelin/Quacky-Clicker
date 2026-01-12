extends Control

## --------------- VARIABLES ---------------

## variables used to manipulate the active powerups

enum State {READY, ACTIVE, COOLDOWN}
var state: State =State.READY
var active_particles: GPUParticles2D

@export var readyTexture: Texture2D
@export var cooldownTexture: Texture2D
@export var activeTexture: Texture2D
@export var particleScene: PackedScene

@onready var button := $Powerup_body
@onready var label := $TimerLabel
@onready var activeTimer := $ActiveTimer
@onready var cooldownTimer := $CooldownTimer



## --------------- FUNCTIONS ---------------

## these functions are declared in each individual active power script
## this script is used as a "base" for all the active powerups wich work in
## their own way

func apply_effect() -> void:
	pass

func remove_effect() -> void:
	pass

func start_active_timer() -> void:
	pass

func start_cooldown_timer() -> void:
	pass


## these functions set the textures to match the powerup's state
## and enables/disables the button so you can't call functions for no reason

func set_ready_state() -> void:
	button.texture_normal = readyTexture
	button.disabled = false

func set_active_state() -> void:
	button.texture_disabled = activeTexture
	button.disabled = true

func set_cooldown_state() -> void:
	button.texture_disabled = cooldownTexture
	button.disabled = true


## this is a gdscript function which triggers every frame
## it's used in this case to update the timer label of the active powerup 
## depending on which state it's in

func _process(_delta) -> void:
	if(state == State.ACTIVE):
		label.text = str(int(ceil(activeTimer.time_left))) + "s"
	elif(state == State.COOLDOWN):
		label.text = "CD: " + str(int(ceil(cooldownTimer.time_left))) + "s"
	else:
		label.text = "Ready"


## function that triggers the animation for the active powerup

func active_animation() -> void:
	if(particleScene == null):
		return
	active_particles = particleScene.instantiate()
	active_particles.global_position = button.global_position + Vector2(75,32)
	get_tree().current_scene.add_child(active_particles)
	active_particles.emitting = true




## --------------- FUNCTIONS TRIGGERED BY SIGNALS ---------------

## this function is triggered when you click the active powerup
## it checks to see if the state is ready and if it is
## it applies the effect of the active powerup, sets the 
## state to active, activates the animation and starts the active timer

func _on_powerup_pressed() -> void:
	if(state != State.READY):
		return
	apply_effect()
	state = State.ACTIVE
	set_active_state()
	active_animation()
	start_active_timer()


## this function is triggered when the active timer finishes
## it checks to see if the state is still active to avoid any glitches
## if the particlese didn't finish on their own, it stops them
## it removes the applied effect, sets the state to cooldown and starts
## the cooldown timer

func _on_active_timer_timeout() -> void:
	
	if(state != State.ACTIVE):
		return
	
	if(active_particles):
		active_particles.emitting = false
		active_particles = null
	
	remove_effect()
	state = State.COOLDOWN
	set_cooldown_state()
	start_cooldown_timer()


## this function triggers when the cooldown timer fnishes
## it sets the state to ready

func _on_cooldown_timer_timeout() -> void:
	state = State.READY
	set_ready_state()


## this function is triggered when the cursor enters the active powerup's hitbox
## it makes the sprite slightly larger

func _on_sprite_mouse_entered() -> void:
	if(button.disabled == true):
		return
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(button, "scale", Vector2(0.074, 0.074), 0.3)


## this function is triggered when the cursor exits the active powerup's hitbox
## it makes the sprite go back to its initial scale

func _on_sprite_mouse_exited() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(button, "scale", Vector2(0.07, 0.07), 0.3)
