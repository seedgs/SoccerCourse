class_name PlayerStatePreppingShot


extends PlayerState


const DURATION_MAX_BONUS := 1000.0
const EASE_PRWARD_FACTOR := 2.0

var shot_direction := Vector2.ZERO
var time_start_shot := Time.get_ticks_msec()



func _enter_tree() -> void:
	animation_player.play("prep_kick") # 进入 “准备射击” 状态后， 进入 “射击动画”
	player.velocity = Vector2.ZERO # 进入 “准备射击” 状态后，玩家 速度 为0（玩家不能移动）
	time_start_shot = Time.get_ticks_msec() # 进入 “准备射击” 状态后，开始计时 

func _process(delta: float) -> void: 
	shot_direction += KeyUtils.get_input_vector(player.control_scheme) * delta # 按下方向键后 的 玩家 按键时间
	if KeyUtils.is_action_just_released(player.control_scheme, KeyUtils.Action.SHOOT): # 进入 “准备射击” 状态后，如果 玩家按键 松开 “射门” 按键
		var duration_press := clampf(Time.get_ticks_msec() - time_start_shot, 0.0, DURATION_MAX_BONUS) # 声明 按压的持续时间 （clampf(1, 2, 3)方法的括号内有3个参数，2(最小值) < 1(你设置的参数) < 3(最大值)）
		var ease_time := duration_press / DURATION_MAX_BONUS # 按压时间 占 总时间的 多少
		var bonus := ease(ease_time, EASE_PRWARD_FACTOR) # 蓄力若干时间后， 玩家射门的力度 （这个力度是曲线图：当 “EASE_PRWARD_FACTOR = 1” 时，你按压射击的时间与力度相同；当 “EASE_PRWARD_FACTOR > 1” 时, 你按压的射击的时间越 “长”，你射门力度越大；当 “EASE_PRWARD_FACTOR < 1” 时,你按压的射击的时间越 “短”，你射门的力度越大）
		var shot_power := player.power * (1 + bonus) # 玩家的 射击力度 = 角色射门的能力数值 * (1 + 玩家的射门力度)
		shot_direction = shot_direction.normalized() # 玩家的射门方向 = 模长的单位向量 (单位时间内的按键坐标和(按键坐标1(x1, y1), 按键坐标2(x2, y2),按键单位时间:n1 和 n2，单位时间内的按键坐标:n1(x1, y1) + n2(x2, y2)) / 模长 (可上网搜 “模长公式”))
		#print(shot_direction, shot_power)
		var data = PlayerStateData.build().set_shot_direction(shot_direction).set_shot_power(shot_power)  # 调用 “PlayerStateData.gd” 的 “build()” 方法的数据
		transition_state(Player.State.SHOOTING, data) # 如果 “state_data” 报错，可以在 “player_state.gd” 的 “setup()” 设置正确的参数，“player.gd” 的 “switch_state()” 也要传递参数！
