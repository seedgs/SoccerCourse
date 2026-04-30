class_name PlayerStatePassing

extends PlayerState

func _enter_tree() -> void:
	animation_player.play("kick")
	#animation_player.play("prep_kick")
	player.velocity = Vector2.ZERO
	

func on_animation_complete() -> void:
	var pass_target := find_teammate_in_view()

	# 当 没有传球目标时
	if pass_target == null:

		# 球的目标 为 球的位置(其实就是原地)，但是！下面加了 数值 “50”，所以球的方向 是 在原地的基础上 横坐标 +50 
		# 方向是：持球玩家(player.heading) 的 方向
		# 需要在 “player.heading” 加一个速度 50，才能使球移动
		ball.pass_to(ball.position + player.heading * 50)
		print(ball.position)
		print(ball.position + player.heading * 50)
	else: # 如果有传球目标
		
		# 球的目标 为 视野最近 目标的位置，方向是：视野最近的目标的方向
		# 这里 添加 “pass_target.velocity” 是 传球至玩家也有 摩擦力效果
		ball.pass_to(pass_target.position + pass_target.velocity)

	transition_state(Player.State.MOVING)


func find_teammate_in_view() -> Player:

	# get_overlapping_bodies() 监测 “teammate_detection_area” 区域内的对象
	var players_in_view := teammate_detection_area.get_overlapping_bodies()
	
	# filter() 过滤掉 “()” 内的内容！
	# 我们需要的是 除了 持球 玩家以外的其他 玩家
	var teammates_in_view := players_in_view.filter(

		# return 后面的是条件，满足这个条件就返回结果
		# 如果 p 不是 持球玩家，返回 这个不是 持球玩家的结果！
		func(p: Player): return p != player 
	)


	# sort_custom() 对 “两组” 及以上 进行排序
	teammates_in_view.sort_custom(

		# return 后面是条件，满足这个条件就返回结果
		# 如果 当前 “玩家” 的距离平方(distance_squared_to()) “小于” 前 “玩家” 的距离平方(distance_squared_to())
		# 由于此刻 teammates_in_view 为 非持球玩家
		# 所以 这些 非持球玩家的距离的平方进行 “由小到大” 排序（“<” 有小到大，“>”由大到小）
		func(p1: Player, p2: Player): return p1.position.distance_squared_to(player.position) < p1.position.distance_squared_to(player.position)
	)

	# size() 返回数组中的 数 
	# 这里是涉及一个 Godot的要点：就是y轴的数值往上 为递减，往下为递增
	# 这里 “teammates_in_view.size() > 0” 是因为 比较两个及以上 非持球玩家离 持球玩家 哪个最近，比较的是y轴的数值
	# 距离最近的 非持球玩家，他的y轴数值的平方也就最大 
	if teammates_in_view.size() > 0: 
		return teammates_in_view[0] # 返回 距离 持球玩家最近的 非持球玩家
	return null
