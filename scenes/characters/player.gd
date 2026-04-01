class_name Player

extends CharacterBody2D

enum ControlScheme {CPU, P1, P2}

@export var control_scheme: ControlScheme

@export var speed: float

@onready var animation_player: AnimationPlayer = %AnimationPlayer 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:

	if control_scheme == ControlScheme.CPU: 
		pass # 只有玩家按下物理键的时候， 电脑（cpu）才执行行动，否则原地不动
	else:
		handle_human_movement()

	set_movement_animation()

	move_and_slide()

	

func handle_human_movement() -> void:
	var direction = KeyUtils.get_input_vector(control_scheme)  # 当你按下物理按键后，人物会移动（移动会根据你的按键去判断是对应哪个人物！！）
	# var direction = Input.get_vector("P1_left", "P1_right", "P1_up", "P1_down")  # 当你按下物理按键后，人物移动

	velocity = direction * speed
	

	# 拓展：人物根据球来判定方向：
	# 如果球在人物的左侧，球的方向往右移动，此时如果按下人物 “右” 方向键，人物朝向为向左，且人物向右移动（俗称的倒退）
	# 如果球在人物的左侧，球的方向往左移动，此时如果按下人物 “左” 方向键，人物朝向为向左，且人物向左移动
	# 按照上述逻辑，人物无论如何移动，朝向始终向着球
	if Input.is_action_pressed("P1_left"):
		$PlayerSprite.flip_h = true
	elif Input.is_action_pressed("P1_right"):
		$PlayerSprite.flip_h = false
	

func set_movement_animation() -> void:
	

	if velocity.length() > 0:
		animation_player.play("run")
	else:
		animation_player.play("idle")

	

	
