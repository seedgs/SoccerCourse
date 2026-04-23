class_name BallStateShot

extends BallState

const SHOT_SPRITE_BALL_SCALE_X := 0.8 # 球 x 方向的缩放数值
const SHOT_SPRITE_BALL_SKEW := 270.0 # 球的 倾斜 数值
const SHOT_SPRITE_BALL_POSITION_Y := -2.0 # 球 y 方向的位置数值
const SHOT_SPRITE_SHADOW_SCALE_X := 0.5 # 球阴影 x 方向的缩放数值
const SHOT_SPRITE_SHADOW_SCALE_Y := 0.7 # 球阴影 y 方向的缩放数值

const BALL_SHOT_DURATION := 1000.0

var ball_shot_finish_time = Time.get_ticks_msec()

func _enter_tree() -> void:
	if ball.velocity.x >= 0:
		animation_player.play("roll")
		animation_player.advance(0)

		# 下面 “sprite_ball” 与 “sprite_shadow” 的参数需要在 “ball.gd” 与 “ball_state.gd” 下写入参数
		sprite_ball.scale.x = -SHOT_SPRITE_BALL_SCALE_X
		sprite_ball.skew = -SHOT_SPRITE_BALL_SKEW
		sprite_ball.position.y = SHOT_SPRITE_BALL_POSITION_Y
		sprite_shadow.scale.x = -SHOT_SPRITE_SHADOW_SCALE_X
		sprite_shadow.scale.y = SHOT_SPRITE_SHADOW_SCALE_Y
		
	else:
		animation_player.play_backwards("roll")
		animation_player.advance(0)
		sprite_ball.scale.x = SHOT_SPRITE_BALL_SCALE_X
		sprite_ball.skew = SHOT_SPRITE_BALL_SKEW
		sprite_ball.position.y = SHOT_SPRITE_BALL_POSITION_Y
		sprite_shadow.scale.x = SHOT_SPRITE_SHADOW_SCALE_X
		sprite_shadow.scale.y = SHOT_SPRITE_SHADOW_SCALE_Y

	ball_shot_finish_time = Time.get_ticks_msec()
	
func _process(delta: float) -> void:
	

	if Time.get_ticks_msec() - ball_shot_finish_time > BALL_SHOT_DURATION:
		state_transition_requested.emit(Ball.State.FREEFORM)
	else:
		ball.move_and_collide(ball.velocity * delta)

func _exit_tree() -> void:
	sprite_ball.scale.x = 1.0
	sprite_ball.skew = 0
	sprite_ball.position.y = 0
	sprite_shadow.scale.x = 0
	sprite_shadow.scale.y = 0
