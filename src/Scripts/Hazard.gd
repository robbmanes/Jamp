extends Node

onready var _animated_sprite := get_node("AnimatedSprite")
onready var _area2d := get_node("Area2D")

func _on_Area2D_body_entered(collision_object):
	if collision_object.has_method("die"):
		collision_object.die()
