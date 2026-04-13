class_name PlayerState

extends Node

signal state_transition_requested(new_state: Player.State) # 发出一个 “状态” 信号！

var animation_player : AnimationPlayer = null # 把“人物”动画方法加载进类里面

var player : Player = null # 把player脚本加载进类里面

func steup(context_player: Player, context_animation_player: AnimationPlayer) -> void:

	player = context_player

	animation_player = context_animation_player