class_name Player extends CharacterBody2D

# o script principal do player

const DEBUG_JUMP_INDICATOR = preload("uid://ct0ubrd7bcblp")

#region /// on ready variables
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_stand: CollisionShape2D = $CollisionStand
@onready var collision_crouch: CollisionShape2D = $CollisionCrouch
@onready var one_way_shape_cast: ShapeCast2D = $OneWayShapeCast
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#endregion

#region /// export variables
@export var move_speed : float = 170
var gravity_multiplier : float = 1.0
@export var max_fall_velocity : float = 600
#endregion

#region State Machine Variables
var states : Array[ PlayerState ]
var current_state : PlayerState : 
	get : return states.front()
var previous_state : PlayerState :
	get : return states [ 1 ]
#endregion

#region standard variables
var direction : Vector2 = Vector2(0, 0)
#endregion

func _ready() -> void: # executa quando o player entra na cena
	initialize_states() # chama a funcao para configurar os estados filhos
	pass

func _unhandled_input(event: InputEvent) -> void: # eventos nao tratados pela interface grafica sao mandados para o jogador
	change_state( current_state.handle_input( event ) ) # puxa o handle input do estado, trocando de estados 
	pass 

func _process( _delta: float) -> void: # executa a cada quadro
	update_direction() # atualiza a direcao do movimento
	change_state( current_state.process( _delta) ) # puxa o process do estado atual
	pass

func _physics_process( delta: float) -> void: # executa a cada passo de fisica
	velocity += get_gravity() * delta * gravity_multiplier # aplica gravidade
	velocity.y = clampf( velocity.y, -1000.0, max_fall_velocity ) # velocidade maxima
	move_and_slide() # move o personagem pela funcao do godot
	change_state( current_state.physics_process( delta ) ) # executa o processo fisico do estado
	pass

func initialize_states() -> void:
	states = [] # armazena todos os estados do player no array
	#gather all the states
	for c in $States.get_children(): 
		if c is PlayerState:
			states.append( c )
			c.player = self # injeta a referencia do player em cada um deles
		pass
	
	if states.size() == 0:
		return
	
	#initialize all the states
	for state in states:  # inicializa todos os estados
		state.init() 
	
	#set our first state
	change_state( current_state ) # configura o estado inicial
	current_state.enter()
	$Label.text = current_state.name
	pass

func change_state( new_state : PlayerState ) -> void: # gerencia transicao de estados
	if new_state == null: # se o  novo estado nao for vazio e for diferente do atual
		return
	elif new_state == current_state:
		return
	
	if current_state: # chama a saida do estado quando troca
		current_state.exit()
	
	states.push_front( new_state ) # coloca o novo estado na frente da lista
	current_state.enter() # chama a entrada do novo estado
	states.resize( 3 ) # reduz a lista de estados para 3
	$Label.text = current_state.name # atualiza o debug
	pass

func update_direction() -> void: # atualiza a direcao (bem simples)
	var prev_direction : Vector2 = direction
	
	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("jump", "down")
	direction = Vector2(x_axis, y_axis)
	
	if prev_direction.x != direction.x:
		if direction.x < 0:
			sprite.flip_h = true
			sprite.position.x = -9
		elif direction.x > 0:
			sprite.flip_h = false
			sprite.position.x = 9
	pass

func add_debug_indicator( color : Color = Color.RED ) -> void: # indicador debug de salto
	var d : Node2D = DEBUG_JUMP_INDICATOR.instantiate()
	get_tree().root.add_child( d )
	d.global_position = global_position
	d.modulate = color
	await get_tree().create_timer( 3.0 ).timeout
	d.queue_free()
	pass
