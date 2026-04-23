class_name BallStateFreeForm

extends BallState


func _enter_tree() -> void:
	player_direction_area.body_entered.connect(on_player_enter.bind()) # 当玩家进入到球的检测区域后，连接并调用 方法

func on_player_enter(body: Player) -> void:

	# 记录谁拿球！（当前为玩家！！！）
	ball.carried = body # 如果去掉这个，ball_state_carried.gd 中 “ball.position = ball.carried.position（当球为携带状态时，球 与 玩家的位置是一致的）” 检测不出 玩家，就会报错！！！
	
	state_transition_requested.emit(Ball.State.CARRIED) # 发送 ball_state.gd里面的 “CARRIED”
 