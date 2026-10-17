class_name PlayerStateJump extends PlayerState

@export var jump_velocity : float = 400

# what happens when this state is initialized?
func init() -> void:
	pass

# what happens when we enter this state?
func enter() -> void:
	player.animation_player.play( "jump" ) # toca animacao
	player.animation_player.pause() # pausa
	# player.add_debug_indicator( Color.LIME_GREEN )
	player.velocity.y = -jump_velocity # aplica velocidade negativa (salto)
	
	# buffer jump bug patch
	# caso o player solte o botao de pulo antes do pulo comeca
	if player.previous_state == fall and not Input.is_action_pressed("jump"):
		await get_tree().physics_frame
		player.velocity.y *= 0.7
		player.change_state( fall )
	pass

# what happens when we exit this state?
func exit() -> void:
	# player.add_debug_indicator( Color.YELLOW )
	pass

# what happens when an input is pressed?
func handle_input( event : InputEvent ) -> PlayerState:
	if event.is_action_released( "jump" ): # se o player soltar o botao, ele cai (jump buffer)
		player.velocity.y *= 0.7
		return fall
	return next_state

func process( _delta: float ) -> PlayerState:
	set_jump_frame() # chama a funcao da animacao dinamica
	return next_state

func physics_process( _delta: float) -> PlayerState: # retorna os estados idle e fall 
	if player.is_on_floor(): # idle se o player tocar o chao
		return idle
	elif player.velocity.y >= 0: # fall se o player comeca a cair
		return fall
	player.velocity.x = player.direction.x * player.move_speed # permite se mover no ar
	return next_state

func set_jump_frame() -> void: # configura o frame do salto baseado na velocidade
	var frame : float = remap( player.velocity.y, -jump_velocity, 0.0, 0.2, 0.4 ) # o frame vai do frame 0.2 da animacao ate o frame 0.4, dependendo da escala da velocidade
	player.animation_player.seek( frame, true )
	pass
