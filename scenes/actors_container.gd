class_name ActorsContainer

extends Node2D

const DURATION_WEIGHT_CACHE := 200

# 需要在场景中显示玩家，所以需要用到玩家节点
const PLAYER_PREFAB := preload("res://scenes/characters/player.tscn")

@export var test : float

@export var ball : Ball

@export var goal_home : Goal

@export var goal_away : Goal

@export var team_home : String

@export var team_away : String

# 创建一个未就绪变量（ @onready）,可供系统自动生成其中内容
@onready var spawns : Node2D = %Spawns

#创建数值储存主客队
var squad_home : Array[Player] = []
var squad_away : Array[Player] = []

var time_since_last_cache_refresh := Time.get_ticks_msec()

func _ready() -> void:
	squad_home = spawn_players(team_home, goal_home)
	spawns.scale.x = -1
	squad_away = spawn_players(team_away, goal_away)
	
	# 从玩家列表选择可控制的角色，[4]与[5]为前锋，并初始化
	var player : Player = get_children().filter(func(p): return p is Player)[4]
	
	# 赋予初始化的角色可控制权
	player.control_scheme = Player.ControlScheme.P1
	
	# 对应角色头顶的符号
	player.set_control_texture()
	
func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_since_last_cache_refresh > DURATION_WEIGHT_CACHE:
		time_since_last_cache_refresh = Time.get_ticks_msec()
		set_on_duty_weights()

# 在场景中实现队伍加载的方法
func spawn_players(country: String, own_goal: Goal) -> Array[Player]:

	var player_nodes : Array[Player] = []

	#从数据加载器中收集了玩家资源，初始化至 “players”
	var players := DataLoader.get_squad(country)
	
	# 传入目标 如果own_goal == goal_away 是 ，则为 goal_home，否则为 goal_away
	# 这里 "goal_home" 与 “goal_away”位置要如下，否则会影响全员面的朝向
	var target_goal := goal_home if own_goal == goal_away else goal_away
	
	#遍历数据字典中的 “players”项，把它们存进 i 中
	for i in players.size():
	
		# 人物的位置为： 把 i 里面的内容 放进 spawns 中 作为 Vertor2数据，初始化至 player_position
		var player_position := spawns.get_child(i).global_position as Vector2
		
		# 人物的数据： 把 players的内容作为（as）资源（PlayerResources）初始化至 player_data
		# 但是资源（PlayerResources）里面的数据是数组 ,players里面是字符串（String）
		# player要转换成数组，也就是 player[i]
		var player_data := players[i] as PlayerResources
		
		#把所有的数据都初始化至 plyer
		var player := spawn_player(player_position, 
									ball, 
									own_goal,
									target_goal, 
									player_data, 
									country)
		
		# 添加并返回玩家数组
		player_nodes.append(player)
		
		#把player加载进场景子节点
		add_child(player)
	
	# 结束前返回（这样就可以访问主客场阵容了，为权重方法提供支撑  ）
	return player_nodes	

func spawn_player(player_postion: Vector2, 
 				ball : Ball,
				own_goal: Goal, 
				target_goal: Goal, 
				player_data: PlayerResources,
				country: String
				) -> Player:
	var player := PLAYER_PREFAB.instantiate()
	player.initialize(player_postion, ball, own_goal, target_goal, player_data, country)
	return player		

# 球员权重分配方法
func set_on_duty_weights() -> void:

	# 访问并遍历球员函数
	for squad in [squad_home, squad_away]:
		
		# 筛选(符合return条件的选项)球员数组中的项（筛选出的球员是CPU控制的球员，这些球员不含守门员，也就是除了守门员之外CPU控制的球员）
		# 这里我们只需要CPU控制 和 不是守门员的球员名单
		var cpu_players :Array[Player] = squad.filter(
			func(p: Player): return p.control_scheme == Player.ControlScheme.CPU and p.role != Player.Role.GOALIE
		)
		
		# 对cpu_players进行排序（sort_custom()方法）
		# cpu_player
		cpu_players.sort_custom(func(p1: Player, p2: Player):
			return p1.spawn_position.distance_squared_to(ball.position) < p2.spawn_position.distance_squared_to(ball.position))
		
		# 为除了守门员之外cpu控制的球员 赋予 权重
		for i in range(cpu_players.size()):
		
			# ease()为缓动函数，简单理解为随着X轴上数值的增加，y轴上数值会逐渐减少
			# 这里cpu_players.size()是从0开始逐渐递增的字符串
			# 
			cpu_players[i].weight_on_duty_steering = 1 - ease(float(i)/10.0, 0.1)
