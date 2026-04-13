class_name PlayerStateTackling

extends PlayerState


const DURATION_TACKLE:= 170 # 设定铲球动画持续时间


var time_start_tackle := Time.get_ticks_msec() # （给铲球动画的时间）返回引擎启动以来经过的时间 


func _enter_tree() -> void:
	animation_player.play("tackle")
	time_start_tackle = Time.get_ticks_msec()

func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_start_tackle > DURATION_TACKLE: # 在铲球状态停留足够的时间，“是”就回到 “移动”， “否”就继续铲球状态
		state_transition_requested.emit(Player.State.MOVING)
