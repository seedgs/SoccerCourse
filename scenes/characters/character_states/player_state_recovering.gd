class_name PlayerStateRecovering

extends PlayerState # 继承玩家状态


const DURATION_RECOVERING := 100 # 设置恢复时间


var time_start_recovering := Time.get_ticks_msec() 


func _enter_tree() -> void: 
	time_start_recovering = Time.get_ticks_msec() # 开始计时
	player.velocity = Vector2.ZERO # 人物速度为 “0”
	animation_player.play("recover") # 进入恢复动画

func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_start_recovering > DURATION_RECOVERING: # 当进入恢复动画后！ 经过设置的恢复时间后
		transition_state(Player.State.MOVING)    # 去到 “移动” 状态
