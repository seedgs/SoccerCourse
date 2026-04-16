class_name BallState

extends Node # 不需要继承


signal state_transition_requested(new_state: BallState ) # 发射信号


var ball : Ball = null # 声明球本身（使其可以给其他脚本使用）
var carried : Player = null # 声明携带 为 “玩家” 
var player_direction_area : Area2D = null # 声明球下的子节点 —— Area2D 

# 设置声明的参数
func setup(context_ball: Ball, context_player_direction_area: Area2D, context_carried: Player) -> void:
	ball = context_ball
	player_direction_area = context_player_direction_area
	carried = context_carried