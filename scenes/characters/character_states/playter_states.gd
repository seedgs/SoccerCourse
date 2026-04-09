class_name PlayerStates

extends Node

signal state_transition_requested(new_state:Player.State)

var player : Player = null

func steup(context_player: Player) -> void:
	player = context_player