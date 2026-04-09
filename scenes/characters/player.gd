class_name Player

extends CharacterBody2D

const DURATION_TACKLE:= 170 # 设定铲球动画持续时间

enum ControlScheme {CPU, P1, P2}

enum State{MOVING, TACKLING}

@export var control_scheme: ControlScheme

@export var speed: float

@onready var animation_player: AnimationPlayer = %AnimationPlayer 

@onready var player_sprite : Sprite2D = %PlayerSprite # player_sprite 被 “赋予” 节点 “Sprite”的 “2D”属性， 否则 player_sprite不可用

var heading := Vector2.RIGHT

var state := State.MOVING # 设定初始状态

var time_start_tackle := Time.get_ticks_msec() # （给铲球动画的时间）返回引擎启动以来经过的时间


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:

	move_and_slide()

	# player_direction()
	
	flip_sprite()

	
		


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
	
