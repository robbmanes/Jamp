# Standard platformer character.  Takes one hit and dies.
# Emits "player_died" signal on death.

extends KinematicBody2D

const UP_DIRECTION := Vector2.UP

var _velocity := Vector2.ZERO
var _curr_direction := 1
onready var _animated_sprite = get_node("AnimatedSprite")
var dead := false # One hit wonder
var playing := false

export var speed := 300.0
export var jump_strength := 850.0
export var gravity := 4000.0

func _ready():
	_play_entrance()

func _physics_process(_delta: float) -> void:
	# Play entrance sprites once and do not allow control briefly
	if not playing:
		return
	
	# We're dead - don't do anything
	if dead:
		return
	
	# Platforming handled here
	_handle_player_movement()

# Player movement handling
func _handle_player_movement() -> void:
	# Handle horizontal movement first
	var _horizontal_direction = (
		Input.get_action_strength("player_move_right")
		- Input.get_action_strength("player_move_left")
	)
	_velocity.x = _horizontal_direction * speed
	
	# Determine direction; leave 0 as whatever the last flip was
	if _horizontal_direction > 0.01:
		_animated_sprite.set_flip_h(false)
	elif _horizontal_direction < -0.01:
		_animated_sprite.set_flip_h(true)
	
	# Go through the state checks and draw sprites
	if is_falling():
		_animated_sprite.play("Falling")
	elif is_jumping():
		_animated_sprite.play("Jumping")
		_velocity.y = -jump_strength
	elif is_jump_cancelled():
		_animated_sprite.play("Falling")
		_velocity.y = 0.0
	elif is_idling():
		_animated_sprite.play("Idling")
	elif is_running():
		_animated_sprite.play("Running")
	else:
		# Hopefully we never get here
		_animated_sprite.play("Idling")

	# Handle vertical movement now
	_velocity.y += gravity * get_physics_process_delta_time()
	
	# Actually draw movement
	_velocity = move_and_slide(_velocity, UP_DIRECTION)

# Various state checks via "is_X" functions
func is_falling() -> bool:
	if _velocity.y > 0.0 and not is_on_floor():
		return true
	return false

func is_jumping() -> bool:
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		return true
	return false

func is_jump_cancelled() -> bool:
	if Input.is_action_just_released("player_jump") and _velocity.y < 0.0:
		return true
	return false

func is_idling() -> bool:
	if is_on_floor() and is_zero_approx(_velocity.x):
		return true
	return false

func is_running() -> bool:
	if is_on_floor() and not is_zero_approx(_velocity.x):
		return true
	return false

# Play entrance animation once and then allow control
func _play_entrance():
	_animated_sprite.play("Entering")
	yield(_animated_sprite, "animation_finished")
	playing = true

# You dead
func die():
	dead = true
	_animated_sprite.play("Dying")
	yield(_animated_sprite, "animation_finished")
	_animated_sprite.queue_free()
	get_tree().reload_current_scene()
	Globals.Score = 0
	Globals.TimeElapsed = 0.0
