class_name PlayerStateTackling

extends PlayerState # 继承玩家状态


const DURATION_TACKLE:= 170 # 设定铲球动画持续时间


var time_start_tackle := Time.get_ticks_msec() # （给铲球动画的时间）返回引擎启动以来经过的时间 


func _enter_tree() -> void:
	animation_player.play("tackle")
	time_start_tackle = Time.get_ticks_msec()

func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_start_tackle > DURATION_TACKLE: # 当进入铲球动画后！ 经过设置的差球时间后
		state_transition_requested.emit(Player.State.RECOVERING) # 去到 “恢复” 状态
