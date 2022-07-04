extends Node

onready var _score_label := get_node("VBoxContainer/ScoreLabel")
onready var _time_label := get_node("VBoxContainer/TimeLabel")
var _time := 0.0
var _seconds := 0.0
var _minutes := 0.0

func _physics_process(delta: float) -> void:
	Globals.TimeElapsed += delta
	_seconds = fmod(Globals.TimeElapsed, 60)
	_minutes = fmod(Globals.TimeElapsed, 3600) / 60
	_score_label.text = "Score: %s" % [Globals.Score]
	_time_label.text = "Time: %02d:%02d" % [_minutes, _seconds]
