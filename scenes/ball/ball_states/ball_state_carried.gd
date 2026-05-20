class_name BallStateCarried

extends BallState

func _enter_tree() -> void:

	# 以下设置是为了传球后，玩家接球的
	# 在球传到另一位玩家的时，
	# 球 “高度” 为 0
	# “速度” 为 0
	# 球的 “精灵体” 的 “位置” 也为 0
	# 也就是说 球不会发生偏移！
	assert(carried != null) 
	ball.height = 0
	ball.height_velocity = 0
	sprite_ball.position = Vector2.ZERO


const OFFSET_FORM_PLAYER_RIGHT := Vector2(10, 2) # 球在携带状态下的偏移量

const OFFSET_FORM_PLAYER_LEFT := Vector2(13, 2) # 球在携带状态下的偏移量

const DRIBBLE_FREQUENCY := 15.0 # 振幅（左右摇摆的快慢）

const DRIBBLE_INTENSITY := 4.0 # 强度 （左右摇摆的跨度）

var dribble_time := 0.0


func _process(delta: float) -> void:

	var vx := 0.0
	dribble_time += delta
	if carried.velocity.x != 0 : # 左右移动时，球 来回摆动
		vx = cos(dribble_time * DRIBBLE_FREQUENCY) * DRIBBLE_INTENSITY # cos值是随时间推移来震荡的！
	elif carried.velocity.y == 0: # 上下移动时，球 停止摆动
		vx = 1.0
	if carried.velocity.x != 0 and carried.velocity.y != 0: # 对角线移动时，球停止移动
		vx = 1.0
	
	ball.ball_state_animation()
	# print("x:", carried.velocity.x, "   y:", carried.velocity.y)

	# 如果“ball_state_freeform.gd” 中的 “on_player_enter()” 方法中的 “ball.carried = body”去掉
	# 代码 无法 判断 是 “谁” 拿到球， 就无法执行下面这 球跟随人的代码！！！
	# 当玩家进入携带区域后， 球的位置就是人的位置（稍微在人的位置偏前一点点）
	# ""carried.heading.x" 人物在左右移动时，保持 球 与 人物 同向

	if ball.carried.heading == Vector2.RIGHT:
		ball.position = ball.carried.position + Vector2(vx + carried.heading.x * OFFSET_FORM_PLAYER_RIGHT.x, OFFSET_FORM_PLAYER_RIGHT.y)
	elif ball.carried.heading == Vector2.LEFT:
		ball.position = ball.carried.position + Vector2(vx + carried.heading.x * OFFSET_FORM_PLAYER_LEFT.x, OFFSET_FORM_PLAYER_LEFT.y)
