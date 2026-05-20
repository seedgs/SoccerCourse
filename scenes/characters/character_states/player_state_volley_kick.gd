class_name PlayerStateVolleyKick

extends PlayerState

const BALL_HEIGHT_MIN := 1.0
const BALL_HEIGHT_MAX := 15.0
const BONUS_POWER := 1.5

func _enter_tree() -> void:
	animation_player.play("volley_kick")
	ball_detection_area.body_entered.connect(on_ball_entered.bind())

func on_ball_entered(contact_ball: Ball) -> void:
	if contact_ball.can_air_connect(BALL_HEIGHT_MIN,BALL_HEIGHT_MAX): # 如果球在空中
	
		# 球的射出后的目标朝向为get_random_target_position()
		# 也就是设定好的随机位置（3选1）
		var destination := target_goal.get_random_target_position() 
		
		# 当然这里的随机位置要传给  球  作为  球的随机位置（且要归一化处理）
		var direction := ball.position.direction_to(destination)
		
		# 球被射出（有方向，有力度）
		contact_ball.shoot(direction * player.power * BONUS_POWER)
		
func on_animation_complete() -> void:

	# 玩家做完动作后，回到恢复状态
	transition_state(Player.State.MOVING)
	
