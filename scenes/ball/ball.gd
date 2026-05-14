class_name Ball

extends AnimatableBody2D # 继承自 AnimatableBody2D

const BOUNCINESS := 0.65
const DISTANCE_HIGH_PASS := 130.0

enum State {CARRIED, FREEFORM, SHOT} # 枚举 球 的状态

@onready var player_direction_area : Area2D = %PlayerDetectionArea # 获取区域的 “引用”（Godot引擎内需要设置“唯一名称访问”） 

@onready var ball_sprite : Sprite2D = %BallSprite # （注意调用的名称）获取精灵节点的 “引用”（Godot引擎内需要设置“唯一名称访问”） 

@onready var ball_shadow_sprite : Sprite2D = %ShadowSprite # （注意调用的名称）获取精灵节点的 “引用”（Godot引擎内需要设置“唯一名称访问”） 

@onready var animation_player : AnimationPlayer = %AnimationPlayer # 获取动画播放器的 “引用”（Godot引擎内需要设置“唯一名称访问”） 


@export var air_connect_max_height : float

@export var air_connect_min_height : float

@export var friction_air : float # 球在空中的摩擦力

@export var friction_ground : float # 球在地面的摩擦力

var carried : Player = null
var current_state : BallState = null # 球当前状态的引用
var height := 0.0
var height_velocity := 0.0
var state_factory := BallStateFactory.new() # 实例化 ball_state_factory.gd
var velocity := Vector2.ZERO # 球的 速度初始为 0



func _ready() -> void:
	switch_state(State.FREEFORM) # 球的状态一开始是 “自由状态”


func _process(_delta: float) -> void:
	ball_sprite.position = Vector2.UP * height



func switch_state(state: Ball.State) -> void:
	if current_state != null: # 如果球的当前状态 不为 null
		current_state.queue_free() # 清除当前状态
	current_state = state_factory.get_fresh_state(state) # 创建 “新” 状态
	current_state.setup(self, 
		player_direction_area, 
		carried, animation_player, 
		ball_sprite, 
		ball_shadow_sprite) # 传入状态数据
	current_state.state_transition_requested.connect(switch_state.bind()) # 球 收到 信号
	current_state.name = "BallStateMachine"
	call_deferred("add_child", current_state)


func ball_state_animation() -> void:
	if carried.velocity != Vector2.ZERO:
		if carried.velocity.x >= 0:
			animation_player.play("roll") # 播放球的滚动动画
			animation_player.advance(0) # advance()强制推进 1 帧，使播放正常！（也可分别设置左右滚动两套动画，并分别绑定！）
		elif carried.velocity.x <= 0 :
			animation_player.play_backwards("roll") # 反向播放动画
			animation_player.advance(0)
	else:
		animation_player.play("idle") # 播放球的静止动画

# 射球瞬间
func shoot(shot_velocity: Vector2) -> void:

	# 这里的 velocity 数值 其实就是  “player_state_shooting.gd” 的 “shoot_ball()” 方法的 state_data.shot_direction * state_data.shot_power 的数值！
	velocity = shot_velocity 

	# 当球射出去后， 没有人触碰到球（可以理解为在空中！）
	carried = null

	# 转为 球的 射击状态，也就是转去 对应的 “ball_state_shot.gd”
	switch_state(Ball.State.SHOT) 


# 传球瞬间
func pass_to(destination: Vector2) -> void:

	# .direction_to() 归一化向量（具体可查“向量归一化”）
	var direction := position.direction_to(destination) # 传球方向 

	# .distance_to()方法可以计算两个坐标轴间的距离
	# 初始坐标为球在射出瞬间的坐标，结束坐标为 “target”坐标”
	var distance := position.distance_to(destination) # 传球的距离

	# 详情可查阅 “information_to_help_understand” 下的资料）
	var intensity := sqrt(2 * distance * friction_ground) # 传球的初速	 
	# “intensity”，其实就是球的初速度 v0
	velocity = intensity * direction # 球的速度 = 球的初速度v0 * 球的方向

	if distance > DISTANCE_HIGH_PASS:
		height_velocity = BallState.GRAVITY * distance / (1.8 * intensity)

	# 球被射出后，没有携带者，所以为 null
	carried = null 

	# 球 射出后,进入自由状态
	switch_state(Ball.State.FREEFORM)


# 球停止时的方法
func stop() -> void:
	velocity = Vector2.ZERO


# 当前球进入的是什么状态的方法
func can_air_intersct() -> bool:

	# 设置了进入球的自由状态 返回 “true”
	# 否则 球为默认状态 返回 “false”
	# 此方法的目的 是 为了检测玩家 是否是 射门或者携带状态
	# 如果是 另一玩家可以 转入 凌空抽射 或者 投球状态
	return current_state != null and current_state.can_air_interact()



func can_air_connect() -> bool:
	return height <= air_connect_max_height and height >= air_connect_min_height 