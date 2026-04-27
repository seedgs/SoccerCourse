class_name PlayerStateShooting

extends PlayerState


func _enter_tree() -> void:
	animation_player.play("kick")

func on_animation_complete() -> void: # 玩家射门状态的 “脚本” 调用了 “PlayerState” 脚本的 "on_animation_complete()"方法
	print("2323232323")
	if player.control_scheme == Player.ControlScheme.CPU:
		transition_state(Player.State.RECOVERING)
	else:
		transition_state(Player.State.MOVING)
	shoot_ball() # 当玩家完成射门动画后下一帧，执行该方法！
	
func shoot_ball() -> void:
	ball.shoot(state_data.shot_direction * state_data.shot_power) # 把 已经计算好的 射门方向参数 与 按键时长的参数 相乘 传至 “ball.gd” 的 “shoot()”方法！
