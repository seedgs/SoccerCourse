class_name Player

extends CharacterBody2D

enum ControlScheme {cpu, P1, P2}

@export var control_scheme: ControlScheme

@export var speed: float = 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	playerMove()


func playerMove() -> void:
	var direction = Input.get_vector("P1_left", "P1_right", "P1_up", "P1_down")
	velocity = direction * speed


	if velocity.length() > 0:
		animation_player.play("run")
	else:
		animation_player.play("idle")


	# 拓展：人物根据球来判定方向：
	# 如果球在人物的左侧，球的方向往右移动，此时如果按下人物 “右” 方向键，人物朝向为向左，且人物向右移动（俗称的倒退）
	# 如果球在人物的左侧，球的方向往左移动，此时如果按下人物 “左” 方向键，人物朝向为向左，且人物向左移动
	# 按照上述逻辑，人物无论如何移动，朝向始终向着球
	if Input.is_action_pressed("P1_left"):
		$PlayerSprite.flip_h = true
	elif Input.is_action_just_pressed("P1_right"):
		$PlayerSprite.flip_h = false

	move_and_slide()
