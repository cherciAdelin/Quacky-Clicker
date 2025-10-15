extends Node2D

@onready var label = $Label

func show_dmg(amount: int):
	$Label.text = str(amount)
	
	var tween := create_tween()
	
	tween.tween_property(self, "position: y", position.y - 30, 0.6)
	tween.parallel().tween_property(self, "modulate", 0.0, 0.6)
	
	tween.finished.connect(queue_free)
