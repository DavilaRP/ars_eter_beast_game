class_name PlayerStateCrouch extends PlayerState

@export var deceleration_rate : float = 12

func init() -> void:
	pass

# what happens when we enter this state?
func enter() -> void:
	player.animation_player.play( "crouch" )
	player.collision_stand.disabled = true
	player.collision_crouch.disabled = false
	player.one_way_shape_cast.force_shapecast_update()
	if player.one_way_shape_cast.is_colliding():
		player.position.y += 4
	pass

# what happens when we exit this state?
func exit() -> void:
	player.collision_stand.disabled = false
	player.collision_crouch.disabled = true
	pass

# what happens when an input is pressed?
func handle_input( _event : InputEvent ) -> PlayerState:
	# handle input
	if _event.is_action_pressed("jump"):
		return jump
	return next_state

func process( _delta: float ) -> PlayerState:
	if player.direction.y <= 0.5:
		return idle
	return next_state

func physics_process( delta: float) -> PlayerState:
	player.velocity.x -= player.velocity.x * deceleration_rate * delta
	if player.is_on_floor() == false:
		return fall
	return next_state
