class_name Ball

extends AnimatableBody2D # 继承自 AnimatableBody2D

enum State {CARRIED, FREEFORM, SHOT} # 枚举 球 的状态

@onready var player_direction_area : Area2D = %PlayerDetectionArea # 获取区域的 “引用”（Godot引擎内需要设置“唯一名称访问”） 

@onready var ball_sprite : Sprite2D = %BallSprite # （注意调用的名称）获取精灵节点的 “引用”（Godot引擎内需要设置“唯一名称访问”） 

@onready var ball_shadow_sprite : Sprite2D = %ShadowSprite # （注意调用的名称）获取精灵节点的 “引用”（Godot引擎内需要设置“唯一名称访问”） 

@onready var animation_player : AnimationPlayer = %AnimationPlayer # 获取动画播放器的 “引用”（Godot引擎内需要设置“唯一名称访问”） 



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
	current_state.setup(self, player_direction_area, carried, animation_player, ball_sprite, ball_shadow_sprite) # 传入状态数据
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


func shoot(shot_virection: Vector2) -> void:
	velocity = shot_virection # 这里的 velocity 数值 其实就是  “player_state_shooting.gd” 的 “shoot_ball()” 方法的 state_data.shot_direction * state_data.shot_power 的数值！
	carried = null # 当球射出去后， 携带者（触碰者）为 null（可以理解为在空中！）
	switch_state(Ball.State.SHOT) # 转为 球的 射击状态，也就是转去 对应的 “ball_state_shot.gd”
