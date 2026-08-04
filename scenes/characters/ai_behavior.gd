class_name AIBehavior

extends Node

const DURATION_TICK_FREQUENCY := 200

#添加AI行为，需要player、ball等依赖项
var ball : Ball = null
var player : Player = null
var time_since_last_ai_tick := Time.get_ticks_msec()



func _ready() -> void:

	# randi_range(0, DURATION_TICK_FREQUENCY):取值范围是为了更流畅，不会出现时间爆发式增长后，突然慢下来再爆发增长的情况
	time_since_last_ai_tick = Time.get_ticks_msec() + randi_range(0, DURATION_TICK_FREQUENCY)

func setup(context_player: Player, context_ball: Ball) -> void:
	player = context_player
	ball = context_ball
	
func process_ai() -> void:

	# 延迟设定的时候后执行当前操作
	if Time.get_ticks_msec() - time_since_last_ai_tick > DURATION_TICK_FREQUENCY:
		time_since_last_ai_tick = Time.get_ticks_msec()
		perform_ai_movement()
		perform_ai_decisions()
	
# AI行为的方法	
func perform_ai_movement() -> void:
	var total_steering_force := Vector2.ZERO
	
	# 不断递增这个力
	total_steering_force += get_onduty_steering_force()
	
	# 人物追踪球时，移动的速度，限制在（ 0,1）之间
	total_steering_force = total_steering_force.limit_length(player.total_steering_force_limit)
	# 根据转向力去影响角色的速度
	player.velocity = total_steering_force * player.speed
	
	
func perform_ai_decisions() -> void:
	pass

# 玩家转向力方法	
func get_onduty_steering_force() -> Vector2:

	# 这个力 需要玩家权重与玩家向 球 的朝向的乘积！
	return player.weight_on_duty_steering * player.position.direction_to(ball.position)
	