@icon( "res://player/states/state.svg" )
class_name PlayerState extends Node

var player : Player
var next_state : PlayerState

#region /// state references
# references
@onready var idle: PlayerStateIdle = %Idle
@onready var run: PlayerStateRun = %Run
@onready var jump: PlayerStateJump = %Jump

#endregion

# what happens when this state is initialized?
func init() -> void:
	pass

# what happens when we enter this state?
func enter() -> void:
	pass

# what happens when we exit this state?
func exit() -> void:
	pass

# what happens when an input is pressed?
func handle_input( _event : InputEvent ) -> PlayerState:
	return next_state

func process( _delta: float ) -> PlayerState:
	return next_state

func physics_process( _delta: float) -> PlayerState:
	return next_state
