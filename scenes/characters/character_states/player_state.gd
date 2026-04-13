class_name PlayerState # 传递Player(父节点)下的子节点的组件

extends Node

signal state_transition_requested(new_state: Player.State) # 发出一个 “状态” 信号！

var animation_player : AnimationPlayer = null # 这里 “animation_player” 是一个引用，目的是通过 “animation_player”，可以直接访问“Player”父节点下的“AnimationPlayer”组件

var player : Player = null # 这里 “player” 是一个引用，目的是通过 “player”，可以直接访问player.gd脚本

func steup(context_player: Player, context_animation_player: AnimationPlayer) -> void: # 创建一个设置方法（"setup()"），分别传入参数

	player = context_player

	animation_player = context_animation_player

# 以下是例子：
"""func steup(a: Player, b: AnimationPlayer) -> void: 

	player = a

	animation_player = b """