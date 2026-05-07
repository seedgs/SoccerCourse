class_name BallStateFreeForm

extends BallState





func _enter_tree() -> void:
	player_direction_area.body_entered.connect(on_player_enter.bind()) # 当玩家进入到球的检测区域后，连接并调用 方法

func on_player_enter(body: Player) -> void:

	# 记录谁拿球！（当前为玩家！！！）
	# 如果去掉这个，ball_state_carried.gd 中 “ball.position = ball.carried.position（当球为携带状态时，球 与 玩家的位置是一致的）” 检测不出 玩家，就会报错！！！
	ball.carried = body 
	
	# 发送 ball_state.gd里面的 “CARRIED”
	state_transition_requested.emit(Ball.State.CARRIED) 

func _process(delta: float) -> void: 
	set_ball_animation_from_velocity() # 球的 “自由状态” 需要处理动画切换问题

	# 如果 球的高度大于 0 (ball.height > 0)，则 用 “FRICTION_AIR”，否则 用 “FRICTION_GROUND”
	var friction := ball.friction_air if ball.height > 0 else ball.friction_ground

	# 设 球的速度的取值范围是 0 - 若干时间 内的 阻力(friction) 数值
	ball.velocity = ball.velocity.move_toward(Vector2.ZERO, friction * delta)
	process_gravity(delta, ball.BOUNCINESS) # 执行 过程中的重力方法（传参：delta 和 BOUNCINESS）
	move_and_bound(delta) # move_and_collide()已经被 move_and_bound()方法所包含，所以里面的参数直接为 delta(增量)
	#ball.move_and_collide(ball.velocity * delta) # 球移动！（自由状态下的球 也需要移动，类似于落地后受摩擦力，然后停下来）
	#print(sprite_ball.position.y)
 
