extends Node2D

onready var _animated_sprite := get_node("AnimatedSprite")
onready var _area2d := get_node("Area2D")

var fruits := ["Apple",
	"Banana",
	"Cherry",
	"Kiwi",
	"Orange",
	"Pineapple",
	"Strawberry",
	"Watermelon"
]
var collected := false
var fruit := "Apple"
export var score := 10

func _ready():
	# Pick one of the fruits at random
	fruits.shuffle()
	fruit = fruits[0]

func _physics_process(_delta):
	if collected:
		return
	_animated_sprite.play(fruit)

func _on_Area2D_body_entered(_body):
	if collected:
		return
	collected = true
	Globals.Score += score
	_animated_sprite.play("Collected")
	yield(_animated_sprite, "animation_finished")
	self.queue_free()
