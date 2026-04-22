class_name Player

extends CharacterBody2D
 
enum ControlScheme {CPU, P1, P2}

enum State {MOVING, TACKLING, RECOVERING, PREPPING_SHOT, SHOOTING}

@export var ball : Ball

@export var control_scheme: ControlScheme # 角色控制归属选择（P1, P2, CPU）

@export var speed: float # 玩家速度

@export var power: float # 角色射门的能力数值

@onready var animation_player: AnimationPlayer = %AnimationPlayer # 获取Player节点下的 AnimationPlayer节点

@onready var player_sprite : Sprite2D = %PlayerSprite # player_sprite 被 “赋予” 节点 “Sprite”的 “2D”属性， 否则 player_sprite不可用


var current_state: PlayerState = null # 玩家当前状态的引用

var heading := Vector2.RIGHT # 设 玩家的默认朝向为 右 

var state_factory := PlayerStateFactory.new()  # 引用 “player_state_facyory”， 并创建新实例



# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	switch_state(State.MOVING)  

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void: # ( )内的 “delta” 如果前面有 “_” 代表此方法的 “delta” 数值被使用，如果 “delta” 没被使用，“_” 应该被加上！

	move_and_slide()

	# player_direction()
	
	flip_sprite()

	


func switch_state(state: Player.State, state_data: PlayerStateData = PlayerStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free() # 现有状态存在就销毁它
	current_state = state_factory.get_fresh_state(state) # 从“player_state_facyory”获取get_fresh_state() 方法，并传入状态
	current_state.steup(self, state_data, animation_player) # self为 player
	current_state.state_transition_requested.connect(switch_state.bind()) # 接收信号，并绑定
	current_state.name = "PlayerStateMachine: " + str(state)
	call_deferred("add_child", current_state) # 把 switch_state()添加为子对象，并延迟调用！
		


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


func has_ball() -> bool: # 检查玩家是否持有球！
	return ball.carried == self # 返回 “球” 的 “持有者” 也就是 “玩家自己”!


func on_animation_complete() -> void: # 这个方法在 父节点 Player 的 “AnimationPlayer” 子节点下的任意一个动画下 “插入关键帧” ！
	if current_state != null: 

		# 第一步：执行动画 完 状态，触发关键帧后来到这里！
		# 第二步：on_animation_complete()被 “PlayerState.gd” 监听！ 
		# 第三步：“PlayerState.gd” 里的 “on_animation_complete()” 被调用的其他状态监听 并 重写内容！
		current_state.on_animation_complete() 

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
	
