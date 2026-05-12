class_name BallStateShot

extends BallState

var SHOT_SPRITE_BALL_SCALE_X := 0.8 # 球 x 方向的缩放数值
var SHOT_SPRITE_BALL_SKEW := 270.0 # 球的 倾斜 数值
var SHOT_SPRITE_BALL_POSITION_Y := 5.0 # 球 y 方向的位置数值
var SHOT_SPRITE_SHADOW_SCALE_X := 0.5 # 球阴影 x 方向的缩放数值
var SHOT_SPRITE_SHADOW_SCALE_Y := 0.7 # 球阴影 y 方向的缩放数值

const BALL_SHOT_DURATION := 800.0

var ball_shot_finish_time = Time.get_ticks_msec()


func _enter_tree() -> void:
	set_ball_animation_from_velocity() # 球的动画播放方法
	ball.height = SHOT_SPRITE_BALL_POSITION_Y # 球的高度等于 预设的垂直高度！
	if ball.velocity.x > 0: # 当 朝右射门时

		# 下面 “sprite_ball” 与 “sprite_shadow” 的参数需要在 “ball.gd” 与 “ball_state.gd” 下写入参数
		sprite_ball.scale.x = -SHOT_SPRITE_BALL_SCALE_X 
		sprite_ball.skew = -SHOT_SPRITE_BALL_SKEW
		sprite_ball.position.y = SHOT_SPRITE_BALL_POSITION_Y
		sprite_shadow.scale.x = -SHOT_SPRITE_SHADOW_SCALE_X
		sprite_shadow.scale.y = SHOT_SPRITE_SHADOW_SCALE_Y

	elif ball.velocity.x < 0: # 当 朝左射门时
		sprite_ball.scale.x = SHOT_SPRITE_BALL_SCALE_X 
		sprite_ball.skew = SHOT_SPRITE_BALL_SKEW
		sprite_ball.position.y = SHOT_SPRITE_BALL_POSITION_Y
		sprite_shadow.scale.x = SHOT_SPRITE_SHADOW_SCALE_X
		sprite_shadow.scale.y = SHOT_SPRITE_SHADOW_SCALE_Y

	
	ball_shot_finish_time = Time.get_ticks_msec() # 开始计时

func _process(delta: float) -> void:
	
	if Time.get_ticks_msec() - ball_shot_finish_time > BALL_SHOT_DURATION: # 球在空中的飞行时间
		state_transition_requested.emit(Ball.State.FREEFORM) # 球经过设定时间后， 恢复 “自由” 状态
	else: # 球还没超过设定时间
		move_and_bound(delta) # move_and_collide()已经被 move_and_bound()方法所包含，所以里面的参数直接为 delta(增量)
		#ball.move_and_collide(ball.velocity * delta) # 球移动！ 球的移动速度为时间的增量

func _exit_tree() -> void: # 状态结束时， 球恢复原有状态
	sprite_ball.scale.x = 1
	sprite_ball.skew = 0
	sprite_ball.position.y = 0
	sprite_shadow.scale.x = 0
	sprite_shadow.scale.y = 0
