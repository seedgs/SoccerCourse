class_name PlayerStateTackling

extends PlayerState # 继承玩家状态


const GURATION_PRIOR_RECOVERY := 10 # 设定铲球动画持续时间
const GROUND_FRICTION := 350.0 # 地面摩擦系数

var is_tackle_complete := false # 完成铲球为 “否”

var time_finish_tackle := Time.get_ticks_msec() # （给铲球动画的时间）返回引擎启动以来经过的时间 


func _enter_tree() -> void:
	animation_player.play("tackle")
	

func _process(delta: float) -> void:
	if not is_tackle_complete: # 如果是铲球
		player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * GROUND_FRICTION) # （也就是实现地面摩擦的方法 ）开始缓速减慢铲球动作
		if player.velocity == Vector2.ZERO: # 直到铲球的速度为 “0” 时
			is_tackle_complete = true # 铲球完成为 “是”
			time_finish_tackle = Time.get_ticks_msec() # 开始计时
	elif Time.get_ticks_msec() - time_finish_tackle > GURATION_PRIOR_RECOVERY: # 当进入铲球动画后！ 经过设置的差球时间后
		state_transition_requested.emit(Player.State.RECOVERING) # 去到 “恢复” 状态



		
