class_name Player extends CharacterBody2D

#region /// export variables
@export var move_speed : float = 170
@export var jump_speed : float = 400
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

func _ready() -> void:
	initialize_states()
	pass

func _unhandled_input(event: InputEvent) -> void:
	change_state( current_state.handle_input( event ) )
	pass 

func _process( _delta: float) -> void:
	update_direction()
	change_state( current_state.process( _delta) )
	pass

func _physics_process( _delta: float) -> void:
	velocity += get_gravity() * _delta
	move_and_slide()
	change_state( current_state.physics_process( _delta) )
	pass

func initialize_states() -> void:
	states = []
	#gather all the states
	for c in $States.get_children():
		if c is PlayerState:
			states.append( c )
			c.player = self
		pass
	
	if states.size() == 0:
		return
	
	#initialize all the states
	for state in states:
		state.init()
	
	#set our first state
	change_state( current_state )
	current_state.enter()
	$Label.text = current_state.name
	pass

func change_state( new_state : PlayerState ) -> void:
	if new_state == null:
		return
	elif new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	
	states.push_front( new_state )
	current_state.enter()
	states.resize( 3 )
	$Label.text = current_state.name
	pass

func update_direction() -> void:
	# var prev_direction : Vector2 = direction
	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("up", "down")
	direction = Vector2(x_axis, y_axis)
	# do more stuff?
	pass
