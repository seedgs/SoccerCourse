class_name PlayerStateMoving

extends PlayerStates

func _process(_delta: float) -> void:
	if player.control_scheme == player.ControlScheme.CPU: 
		pass 
	else:
		if player.state == player.State.MOVING:
			handle_human_movement()
			if player.velocity.x != 0 and KeyUtils.is_action_just_pressed(player.control_scheme, player.KeyUtils.Action.SHOOT): # 当人物移动（velocity.x 不等于0时） 和 按下“shoot”按键时， 启动铲球动作
				player.state = player.State.TACKLING
				player.time_start_tackle = Time.get_ticks_msec()
			player.set_movement_animation()
		elif player.state == player.State.TACKLING:
			player.animation_player.play("tackle")
			if player.Time.get_ticks_msec() - player.time_start_tackle > player.DURATION_TACKLE: # 铲球动画持续时间（经过 DURATION_TACKLE 设定的时候后变回移动状态）
				player.state = player.State.MOVING

	player.set_heading()

func handle_human_movement() -> void: #人物操控

	var direction = KeyUtils.get_input_vector(player.control_scheme)  # 当你按下物理按键后，人物会移动（移动会根据你的按键去判断是对应哪个人物！！）
	# var direction = Input.get_vector("P1_left", "P1_right", "P1_up", "P1_down")  # 当你按下物理按键后，人物移动

	player.velocity = direction * player.speed
