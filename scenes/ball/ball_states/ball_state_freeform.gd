class_name BallStateFreeForm

extends BallState

const BOUNCINESS := 0.65
const FRICTION_AIR := 3.5
const FRICTION_GROUND := 250.0


func _enter_tree() -> void:
	player_direction_area.body_entered.connect(on_player_enter.bind()) # 当玩家进入到球的检测区域后，连接并调用 方法

func on_player_enter(body: Player) -> void:

	# 记录谁拿球！（当前为玩家！！！）
	ball.carried = body # 如果去掉这个，ball_state_carried.gd 中 “ball.position = ball.carried.position（当球为携带状态时，球 与 玩家的位置是一致的）” 检测不出 玩家，就会报错！！！
	
	state_transition_requested.emit(Ball.State.CARRIED) # 发送 ball_state.gd里面的 “CARRIED”
 

func _process(delta: float) -> void: 
	set_ball_animation_from_velocity() # 球的 “自由状态” 需要处理动画切换问题

	# 如果 球的高度大于 0 (ball.height > 0)，则 用 “FRICTION_AIR”，否则 用 “FRICTION_GROUND”
	var friction := FRICTION_AIR if ball.height > 0 else FRICTION_GROUND

	# 设 球的速度的取值范围是 0 - 若干时间 内的 阻力(friction) 数值
	ball.velocity = ball.velocity.move_toward(Vector2.ZERO, friction * delta)
	process_gravity(delta, BOUNCINESS) # 执行 过程中的重力方法（传参：delta 和 BOUNCINESS）
	ball.move_and_collide(ball.velocity * delta) # 球移动！（自由状态下的球 也需要移动，类似于落地后受摩擦力，然后停下来）
	#print(sprite_ball.position.y)
 
