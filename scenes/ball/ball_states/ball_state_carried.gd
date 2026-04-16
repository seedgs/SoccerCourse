class_name BallStateCarried

extends BallState

func _enter_tree() -> void:
	assert(carried != null) 


func _process(_delta: float) -> void:

	# 如果“ball_state_freeform.gd” 中的 “on_player_enter()” 方法中的 “ball.carried = body”去掉
	# 代码 无法 判断 是 “谁” 拿到球， 就无法执行下面这 球跟随人的代码！！！

	ball.position = ball.carried.position # 当玩家进入携带区域后， 球的位置就是人的位置（稍微在人的位置偏前一点点）
