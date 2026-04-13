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

	player.velocity = direction * player.speed



	if player.velocity != Vector2.ZERO and KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
		state_transition_requested.emit(Player.State.TACKLING)
 

