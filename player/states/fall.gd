class_name PlayerStateFall extends PlayerState

@export var fall_gravity_multiplier : float = 1.165
@export var coyote_time : float = 0.1
@export var jump_buffer_time : float = 0.08

var coyote_timer : float = 0
var buffer_timer : float = 0

# what happens when this state is initialized?
func init() -> void:
	pass

# what happens when we enter this state?
func enter() -> void:
	player.gravity_multiplier = fall_gravity_multiplier
	if player.previous_state == jump:
		coyote_timer = 0
	else:
		coyote_timer = coyote_time 
	pass

# what happens when we exit this state?
func exit() -> void:
	player.gravity_multiplier = 1.0
	pass

# what happens when an input is pressed?
func handle_input( event : InputEvent ) -> PlayerState:
	if event.is_action_pressed( "jump" ):
		if coyote_timer > 0:
			return jump
		else:
			buffer_timer = jump_buffer_time
	return next_state

func process( delta: float ) -> PlayerState:
	coyote_timer -= delta
	buffer_timer -= delta
	return next_state

func physics_process( _delta: float) -> PlayerState:
	if player.is_on_floor(): 
		player.add_debug_indicator( Color.RED )
		if buffer_timer > 0:
			return jump
		return idle
	player.velocity.x = player.direction.x * player.move_speed
	return next_state
