class_name Player

extends CharacterBody2D

enum ControlScheme {CPU, P1, P2}

enum Role {GOALIS,
		DEFENS,
		MIDFIELD,
		OFFENSE}
		
enum SkinColor{LIGHT,
			MEDIUM,
			DARK}

enum State {
	BICYCLE_KICK,
	CHEST_CONTROL,
	HEADER,
	MOVING,
	PASSING,
	PREPPING_SHOT, 
	RECOVERING,
	SHOOTING, 
	TACKLING,
	VOLLEY_KICK,}

@export var ball : Ball

@export var control_scheme: ControlScheme # 角色控制归属选择（P1, P2, CPU）

@export var own_goal : Goal

@export var power: float # 角色射门的能力数值

@export var speed: float # 玩家速度

@export var target_goal : Goal


@onready var animation_player: AnimationPlayer = %AnimationPlayer # 获取Player节点下的 AnimationPlayer节点

@onready var ball_detection_area : Area2D = %BallDetectionArea

@onready var player_sprite : Sprite2D = %PlayerSprite # player_sprite 被 “赋予” 节点 “Sprite”的 “2D”属性， 否则 player_sprite不可用

@onready var teammate_detection_area : Area2D = %TeammateDetectionArea



# 创建图片的 “控制角色” 的 字典索引
const CONTROL_SCHEME_MAP : Dictionary = {
	ControlScheme.CPU: preload("res://assets/art/props/cpu.png"),
	ControlScheme.P1: preload("res://assets/art/props/1p.png"),
	ControlScheme.P2: preload("res://assets/art/props/2p.png"),
}

const BALL_CONTROL_HIGHT_MAX := 10.0

const GRAVITY := 8.0

@onready var control_sprite : Sprite2D = %ControlSprite

var current_state: PlayerState = null # 玩家当前状态的引用
	
var heading := Vector2.RIGHT # 设 玩家的默认朝向为 右 

var height := 0.0

var height_velocity := 0.0

var state_factory := PlayerStateFactory.new()  # 引用 “player_state_facyory”， 并创建新实例



# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	switch_state(State.MOVING)
	set_control_texture()

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: # ( )内的 “delta” 如果前面有 “_” 代表此方法的 “delta” 数值被使用，如果 “delta” 没被使用，“_” 应该被加上！

	move_and_slide()

	# player_direction()

	process_gravity(delta)
	
	flip_sprite()

	set_sprite_visibility()


func switch_state(
	state: Player.State, 
	state_data: PlayerStateData = PlayerStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free() # 现有状态存在就销毁它
	current_state = state_factory.get_fresh_state(state) # 从“player_state_facyory”获取get_fresh_state() 方法，并传入状态
	
	# (传入的参数可以给依赖 “Player” 的脚本任意调用！！！)self为 player（传参的顺序按照 “player_state.gd” 的 “setup()” 传参顺序 ）
	# 修改建议：这里有点长了，可以建立一个包含下面所有依赖项的对象，只需传递这个对象即可
	current_state.steup(
		animation_player, 
		ball, 
		ball_detection_area, 
		own_goal,
		self, 
		state_data, 
		target_goal,
		teammate_detection_area)
	
	# 接收信号，并绑定
	current_state.state_transition_requested.connect(switch_state.bind()) 
	current_state.name = "PlayerStateMachine: " + str(state)

	# 把 switch_state()添加为子对象，并延迟调用！
	call_deferred("add_child", current_state)
		


func process_gravity(delta) -> void:
	if height > 0:

		# 随时间持续 递减 GRAVITY（每秒减少GRAVITY数值）
		# 并传入 height_velocity
		height_velocity -= GRAVITY * delta

		# 每秒减少GRAVITY数值 并递增
		# 传入 height
		# 第一次循环 递增 8，第二次循环 递增 0
		height += height_velocity

		if height <= 0:
			height = 0
	
	# 玩家 下面的 阴影的位置 是 上升 height数值（也是就8px）
	player_sprite.position = Vector2.UP * height


func set_movement_animation() -> void: # 人物动画状态

	if velocity.length() > 0:
		animation_player.play("run")
	else:
		animation_player.play("idle")





# 这个方法是根据 “二维向量” 的，所以不出现控制 “P1”，导致 “P2” 会格个跟随 “反应”
func set_heading() -> void: # 人物方向设定
	
	if velocity.x > 0: # 当人物X轴方向大于0（也就是人物向右移动）
		heading = Vector2.RIGHT # heading 被赋予 二维向量（1，0）
		
	elif velocity.x < 0: # 当人物X轴方向小于0（也就是人物向左移动）
		heading = Vector2.LEFT # heading 被赋予 二维向量（-1，0）
	
func flip_sprite() -> void: # 人物转向

	if heading == Vector2.RIGHT:
		player_sprite.flip_h = false # 这里 player_sprite 也可以换成 “$PlayerSprite”  
	elif heading == Vector2.LEFT:
		player_sprite.flip_h = true

func set_sprite_visibility() -> void:

	# 持球的玩家 或者 控制者 “不” 是 CPU的时候 玩家头顶的图片 “隐藏”！
	# 也就是 玩家P1、P2显示头顶图片，CPU拿到球时也显示头顶图片！
	control_sprite.visible = has_ball() or not control_scheme == ControlScheme.CPU

func has_ball() -> bool: # 检查玩家是否持有球！
	return ball.carried == self # 返回 “球” 的 “持有者” 也就是 “玩家自己”!

func set_control_texture() -> void:
	# 玩家头顶的子节点 “ControlSprite” 的 质地 “texture” 为 字典的 控制方案
	control_sprite.texture = CONTROL_SCHEME_MAP[control_scheme]

func on_animation_complete() -> void: # 这个方法在 父节点 Player 的 “AnimationPlayer” 子节点下的任意一个动画下 “插入关键帧” ！
	if current_state != null: 

		# 第一步：执行动画 完 状态，触发关键帧后来到这里！
		# 第二步：on_animation_complete()被 “PlayerState.gd” 监听！ 
		# 第三步：“PlayerState.gd” 里的 “on_animation_complete()” 被调用的其他状态监听 并 重写内容！
		current_state.on_animation_complete() 

func control_ball() -> void:
	if ball.height > BALL_CONTROL_HIGHT_MAX:
		switch_state(Player.State.CHEST_CONTROL)



# 这个方法的弊端就是，按下左右按键，系统无法判断是来自 “P1” 还是 “P2”
# func player_direction() -> void: # 人物转向

# 	# 拓展：人物根据球来判定方向：
# 	# 如果球在人物的左侧，球的方向往右移动，此时如果按下人物 “右” 方向键，人物朝向为向左，且人物向右移动（俗称的倒退）
# 	# 如果球在人物的左侧，球的方向往左移动，此时如果按下人物 “左” 方向键，人物朝向为向左，且人物向左移动
# 	# 按照上述逻辑，人物无论如何移动，朝向始终向着球
# 	if Input.is_action_pressed("P1_left") or Input.is_action_pressed("P2_left"):
# 		$PlayerSprite.flip_h = true
# 	elif Input.is_action_pressed("P1_right") or Input.is_action_pressed("P2_right"):
# 		$PlayerSprite.flip_h = false
	
