class_name BallState

extends Node # 不需要继承

const GRAVITY := 10.0

signal state_transition_requested(new_state: BallState ) # 发射信号


var ball : Ball = null # 声明球本身（使其可以给其他脚本使用）
var carried : Player = null # 声明携带 为 “玩家” 
var player_direction_area : Area2D = null # 声明球下的子节点 —— Area2D 
var animation_player : AnimationPlayer = null 
var sprite_ball : Sprite2D = null
var sprite_shadow : Sprite2D = null


# 设置声明的参数
func setup(context_ball: Ball, context_player_direction_area: Area2D, context_carried: Player, context_animation: AnimationPlayer, context_sprite_ball: Sprite2D, context_sprite_shadow: Sprite2D) -> void:
	ball = context_ball
	player_direction_area = context_player_direction_area
	carried = context_carried
	animation_player = context_animation
	sprite_ball = context_sprite_ball
	sprite_shadow = context_sprite_shadow

func set_ball_animation_from_velocity() -> void:
	if ball.velocity == Vector2.ZERO: # 球速度为 0 时
		animation_player.play("idle") # 播放停止 动画
	elif ball.velocity.x > 0: # 球的水平速度 大于 0 时
		animation_player.play("roll") # 播放停止 滚动动画
		animation_player.advance(0) # 跳过一帧（为了播放顺畅）
	else: # 球的水平速度 小于等于 0时
		animation_player.play_backwards("roll") # 播放 反向 滚动动画
		animation_player.advance(0) # 跳过一帧（为了播放顺畅）

func process_gravity(delta: float, bounciness : float =  0.0) -> void:
	if ball.height > 0 or ball.height_velocity > 0: # 如果 球在空中 和 球的高度速度 大于 0（球下落，但没有落地） 时

		# 这里需要注意！ 因为一开始 设 ball.height 为 正数！ball.height_velocity 也设为 正数！
		# 因为球射击状态，球 朝上 为 正数，球如果下降，下降高度为负数，一正一负才能相互抵消
		# 正因为 “ball.height_velocity” 一开始设为正数，为了相互抵消，下面等式才会反过来！

		ball.height_velocity -= GRAVITY * delta # 球在空中下落时的速度 为 随时间的 GRAVITY值（为负数）
		ball.height += ball.height_velocity # 球的高度（ball.height） = 球的高度（ball.height） + 高度的速度（ball.height_velocity “负数”）  
		if ball.height < 0:  # 因为 “ball.height_velocity” 数值 是 随时间推移的无限大 负值， 所以当 球高度 小于 0 的瞬间
			ball.height = 0 # 球的高度 为 0 （也就是球马上贴地， 如果去掉，球会不停往下移动！）
			if bounciness > 0 and ball.height_velocity < 0:
				ball.height_velocity = -ball.height_velocity * bounciness # 这一次的 “ball.height_velocity”方向 等于 上一次的 “ball.height_velocity”的反方向  乘以  0.65(bounciness数值，该数值通过 ball_state_freeform.gd 设定！)
				ball.velocity *= bounciness # 球的每次弹起来，下去！弹起来！下去 的速度为 bounciness = 0.65 (因为 ball.velocity 为 Vector2类型， bounciness为 float类型， 需要 *= 去划等，表示为 ball.velocity中的每个分量 (x, y) 分别乘以 bounciness数值)

# 球触碰球门后反弹的方法
func move_and_bound(delta: float) -> void:

	# .move_and_clooide()此方法会返回 一些参数（具体看详解）
	# 我们需要这些参数，所以把他 声明，以便使用
	# .move_and_collide() 可以检测出碰撞体，并返回碰撞信息
	var collision := ball.move_and_collide(ball.velocity * delta)
	if collision != null: # 检查是否发生碰撞（检查球是否碰到门框）
	
		# .bounce() （计算反弹后的方向向量）返回从给定法线参数n定义的垂直于直线的直线“反弹”的向量。
		# .get_normal() 获取碰撞表面的法线方向！
		# 计算一个物体的反弹，1、要知道反弹的方向，2、要知道反弹的力度（初速度）
		# .bounce()就是计算 初速度的，.get_normal()就是提供方向的！
		ball.velocity = ball.velocity.bounce(collision.get_normal()) * ball.BOUNCINESS

		# ball_state.gd为父类
		# ball_state_shot.gd为子类
		# 若修改 ball_state_shot.gd子类 的内容
		# 可以 按照下面方法去写（self 为 父类 也就是本脚本）
		if self is BallStateShot: # 这里修改的是 球 在碰到门框后，球反弹的效果
			_exit_tree() # 也就是当球碰到门框后，球就不再形变，只有摩擦力！ 