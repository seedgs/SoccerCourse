class_name PlayerStateMoving

extends PlayerState # 继承玩家状态

func _process(_delta: float) -> void:

	
	if player.control_scheme == player.ControlScheme.CPU: 
		pass  
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
	# 如果是 另一玩家可以 转入 凌空抽射 或者 投球状态
	elif ball.can_air_intersct() and KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
		
		# 当一名玩家处于 射门或者携带状态 和 按下射门按键后
		# 另一名玩家 如果移动速度为 0 
		if player.velocity == Vector2.ZERO: 
			pass
		else:

			# 另一名玩家 在移动的过程中，执行投球动作
			transition_state(Player.State.HEADER)


	# 如果 玩家 速度不为 0 且 按下 铲球 按钮，玩家 进入 铲球状态！
	#if player.velocity != Vector2.ZERO and KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
		#transition_state(Player.State.TACKLING)
 
