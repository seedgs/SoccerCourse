
class_name Goal

extends Node2D

@onready var back_net_area := $BackNetArea

@onready var targets := $Targets

func _ready() -> void:

	# “body_entered” 当接收到的参数体进入此区域时触发
	back_net_area.body_entered.connect(on_ball_enter_back_net.bind())


func on_ball_enter_back_net(ball:Ball) -> void:
	ball.stop()
	
	
func get_random_target_position() -> Vector2:

	# 获取Targets父节点下的子节点
	# 获取范围为 0 - Targets父节点下的子节点数
	# 但由于 0代表第 “一” 个位置，而 “targets.get_child_count()”取值为 3（因为 “Targets” 下有3个子节点）
	# 3代表第 “四” 的位置，第四个位置是没有子节点的，所以这里需要  “-1”
	return targets.get_child(randi_range(0, targets.get_child_count() - 1)).global_position
