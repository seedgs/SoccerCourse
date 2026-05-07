class_name Goal

extends Node2D

@onready var back_net_area := $BackNetArea

func _ready() -> void:

	# “body_entered” 当接收到的参数体进入此区域时触发
	back_net_area.body_entered.connect(on_ball_enter_back_net.bind())


func on_ball_enter_back_net(ball:Ball) -> void:
	ball.stop()