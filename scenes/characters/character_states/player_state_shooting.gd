class_name PlayerStateShooting

extends PlayerState


func _enter_tree() -> void:
	animation_player.play("kick")

func on_animation_complete() -> void: # 玩家射门状态的 “脚本” 调用了 “PlayerState” 脚本的 "on_animation_complete()"方法
	if player.control_scheme == Player.ControlScheme.CPU:
		transition_state(Player.State.RECOVERING)
	else:
		transition_state(Player.State.MOVING)
	shoot_ball()

func shoot_ball() -> void:
	print(state_data)