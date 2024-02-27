extends Node


var game_pause : bool

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		game_pause = !game_pause
	if game_pause == true:
		get_tree().paused = true
		
	else:
		get_tree().paused = false
	
