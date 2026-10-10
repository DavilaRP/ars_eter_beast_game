class_name PlayerStateCrouch extends PlayerState

@export var deceleration_rate : float = 12

func init() -> void:
	pass

# what happens when we enter this state?
func enter() -> void:
	# animation
	player.collision_stand.disabled = true
	player.collision_crouch.disabled = false
	player.sprite.scale.y = 0.625
	player.sprite.position.y = -10
	if player.one_way_platform_raycast.is_colliding() == true:
		player.position.y += 4
	pass

# what happens when we exit this state?
func exit() -> void:
	player.collision_stand.disabled = false
	player.collision_crouch.disabled = true
	player.sprite.scale.y = 1.0
	player.sprite.position.y = -16
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
