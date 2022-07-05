extends "res://src/Scripts/Hazard.gd"

func _physics_process(_delta: float) -> void:
	_animated_sprite.play("Spinning")
