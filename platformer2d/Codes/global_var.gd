extends Node

var lives = 4
var coins = 0
var punto

func _ready():
	self.pause_mode = PAUSE_MODE_PROCESS

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused == false:
			get_tree().paused = true
		else:
			get_tree().paused = false
	
	if lives == 0 and punto == null:
		print("Perdiste")
		get_tree().quit()