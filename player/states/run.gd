class_name PlayerStateRun extends PlayerState

func init() -> void:
	pass

# what happens when we enter this state?
func enter() -> void:
	# run animation
	pass

# what happens when we exit this state?
func exit() -> void:
	pass

# what happens when an input is pressed?
func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed("jump"):
		return jump
	return next_state

func process( _delta: float ) -> PlayerState:
	if player.direction.x == 0:
		return idle
	return next_state

func physics_process( _delta: float) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	if player.is_on_floor() == false:
		return fall
	return next_state
