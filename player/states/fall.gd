class_name PlayerStateFall extends PlayerState

@export var fall_gravity_multiplier : float = 1.5
@export var coyote_time : float = 0.075
@export var jump_buffer_time : float = 0.08

var coyote_timer : float = 0
var buffer_timer : float = 0

# what happens when this state is initialized?
func init() -> void:
	pass

# what happens when we enter this state?
func enter() -> void:
	player.animation_player.play( "jump" )
	player.animation_player.pause()
	player.gravity_multiplier = fall_gravity_multiplier
	if player.previous_state == jump:
		coyote_timer = 0
	else:
		coyote_timer = coyote_time 
	pass

# what happens when we exit this state?
func exit() -> void:
	player.gravity_multiplier = 1.0
	buffer_timer = 0
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
	set_jump_frame()
	return next_state

func physics_process( _delta: float) -> PlayerState:
	if player.is_on_floor(): 
		# player.add_debug_indicator( Color.RED )
		if buffer_timer > 0:
			return jump
		return idle
	player.velocity.x = player.direction.x * player.move_speed # permite se movimentar no ar
	return next_state

func set_jump_frame() -> void: # configura o frame do salto baseado na velocidade
	var frame : float = remap( player.velocity.y, 0.0, player.max_fall_velocity, 0.5, 0.7 ) # o frame vai do frame 0.2 da animacao ate o frame 0.4, dependendo da escala da velocidade
	player.animation_player.seek( frame, true )
	pass
