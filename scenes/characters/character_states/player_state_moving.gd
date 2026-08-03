class_name PlayerStateMoving



extends PlayerState # 继承玩家状态

const BALL_HEIGHT_MIN := 10.0
const BALL_HEIGHT_MAX := 30.0

func _process(_delta: float) -> void:

	
	if player.control_scheme == player.ControlScheme.CPU: 
		ai_behavior.process_ai()  
	else:
		handle_human_movement()
		
	player.set_movement_animation()

	player.set_heading()
	


func handle_human_movement() -> void: #人物操控

	var direction = KeyUtils.get_input_vector(player.control_scheme)  # 当你按下物理按键后，人物会移动（移动会根据你的按键去判断是对应哪个人物！！）
	# var direction = Input.get_vector("P1_left", "P1_right", "P1_up", "P1_down")  # 当你按下物理按键后，人物移动

	player.velocity = direction * player.speed # 玩家的速度 为 按键的方向 与 玩家速度的 乘积

	if player.velocity != Vector2.ZERO:
		teammate_detection_area.rotation = player.velocity.angle() 

	# 玩家持球
	if player.has_ball():

		# 如果按下 传球按键
		if KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.PASS):
			
			# 进入传球状态
			transition_state(player.State.PASSING)

		# 如果 射门按键
		elif KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
			
			# 进入射门状态
			transition_state(player.State.PREPPING_SHOT)

	# can_air_intersct()方法是
	# 为了检测玩家 是否是 射门或者携带状态
	# 如果是 另一玩家可以 转入 凌空 ) and KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
		
		# 当一名玩家处于 射门或者携带状态 和 按下射门按键后
		# 另一名玩家 如果移动速度为 0 
	elif ball.can_air_connect(BALL_HEIGHT_MIN, BALL_HEIGHT_MAX) and KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
		if player.velocity == Vector2.ZERO: 
			if is_facing_target_goal(): # 玩家面向目标
				transition_state(Player.State.VOLLEY_KICK)
			else: # 玩家面向己方球门
				transition_state(Player.State.BICYCLE_KICK)
		else:
			# 另一名玩家 在移动的过程中，执行投球动作
			transition_state(Player.State.HEADER)


	# 如果 玩家 速度不为 0 且 按下 铲球 按钮，玩家 进入 铲球状态！
	#if player.velocity != Vector2.ZERO and KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
		#transition_state(Player.State.TACKLING)
func is_facing_target_goal() -> bool:

	if target_goal == null:
		return false
	
	# 玩家移动的方向向量（并归一化）
	# 这里 不能使用 “player.position”（局部变量），需要使用 “global_position”（全局变量）
	# 因为 在Godot里面，所有节点都是 局部变量，需要改换成全局变量
	var direction_to_target_goal := player.global_position.direction_to(target_goal.global_position)

	# 根据玩家移动的方向向量 与 玩家朝向的向量的 “点积” 
	# 
	# 得出的数值是 >0 还是 <0 
	# 来判断此时的玩家是面朝  对方球门  还是  自己球门  
	return player.heading.dot(direction_to_target_goal) > 0 # 这个点积设为 >0，也就是玩家面向目标
	
