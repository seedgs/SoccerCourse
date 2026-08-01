class_name ActorsContainer

extends Node2D

# 需要在场景中显示玩家，所以需要用到玩家节点
const PLAYER_PREFAB := preload("res://scenes/characters/player.tscn")

@export var ball : Ball

@export var goal_home : Goal

@export var goal_away : Goal

@export var team_home : String

@export var team_away : String

# 创建一个未就绪变量（ @onready）,可供系统自动生成其中内容
@onready var spawns : Node2D = %Spawns

func _ready() -> void:
	spawn_players(team_home, goal_home)
	spawns.scale.x = -1
	spawn_players(team_away, goal_away)
	
	# 从玩家列表选择可控制的角色，[4]与[5]为前锋，并初始化
	var player : Player = get_children().filter(func(p): return p is Player)[4]
	
	# 赋予初始化的角色可控制权
	player.control_scheme = Player.ControlScheme.P1
	
	# 对应角色头顶的符号
	player.set_control_texture()

# 在场景中实现队伍加载的方法
func spawn_players(country: String, own_goal: Goal) -> void:

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
		
		#把player加载进场景子节点
		add_child(player)

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
