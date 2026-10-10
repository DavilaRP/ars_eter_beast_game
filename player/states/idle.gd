class_name PlayerStateIdle extends PlayerState

func init() -> void:
	pass

# what happens when we enter this state?
func enter() -> void:
	# animation
	pass

# what happens when we exit this state?
func exit() -> void:
	pass

# what happens when an input is pressed?
func handle_input( _event : InputEvent ) -> PlayerState:
	# handle input
	if _event.is_action_pressed("jump"):
		return jump
	return next_state

func process( _delta: float ) -> PlayerState:
	if player.direction.x != 0:
		return run
	elif player.direction.y > 0.5:
		return crouch
		pass
	return next_state

func physics_process( _delta: float) -> PlayerState:
	player.velocity.x = 0
	if player.is_on_floor() == false:
		return fall
	return next_state
