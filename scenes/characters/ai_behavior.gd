class_name AIBehavior

extends Node

const DURATION_TICK_FREQUENCY := 200

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
	print(name + " moving")
	
func perform_ai_decisions() -> void:
	pass
	