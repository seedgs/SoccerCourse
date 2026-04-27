class_name PlayerState # 传递Player(父节点)下的子节点的组件

extends Node

# 这里 “State_data: PlayerStateData” 是发送来自 “Player_state_data.gd” 的 数据
signal state_transition_requested(new_state: Player.State, State_data: PlayerStateData) # 发出一个 “状态” 信号！

var animation_player : AnimationPlayer = null # 这里 “animation_player” 是一个引用，目的是通过 “animation_player”，可以直接访问“Player”父节点下的“AnimationPlayer”组件

var player : Player = null # 这里 “player” 是一个引用，目的是通过 “player”，可以直接访问player.gd脚本

var state_data : PlayerStateData = PlayerStateData.new()

var ball : Ball = null

var teammate_detection_area : Area2D = null

func steup(context_animation_player: AnimationPlayer, context_ball: Ball, context_player: Player, context_data: PlayerStateData, conetxt_teammate_detection_area: Area2D) -> void: # 创建一个设置方法（"setup()"），分别传入参数

	animation_player = context_animation_player

	ball = context_ball

	player = context_player

	state_data = context_data

	teammate_detection_area = conetxt_teammate_detection_area

	

# 这个方法 可以使 “state_transition_requested.emit()” 直接变成 “trainsition_state()” 被调用
# 这个方法也包括可以使用 “trainsition_state()” 内的参数，只要在 “signal state_transition_requested()” 内设置参数即可
func transition_state(new_state: Player.State, state_data: PlayerStateData = PlayerStateData.new()) -> void:
	state_transition_requested.emit(new_state, state_data)

func on_animation_complete() -> void: # 此处的方法 为空， 任何状态脚本可以调用这个方法，并重写
	pass

# 以下是例子：
"""func steup(a: Player, b: AnimationPlayer) -> void: 

	player = a

	animation_player = b """



