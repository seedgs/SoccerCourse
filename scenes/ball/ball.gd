class_name Ball

extends AnimatableBody2D # 继承自 AnimatableBody2D

enum State {CARRIED, FREEFORM, SHOT} # 枚举 球 的状态

@onready var player_direction_area : Area2D = %PlayerDetectionArea # “引用” ball下的子节点 Area2D

var carried : Player = null
var current_state : BallState = null # 球当前状态的引用
var state_factory := BallStateFactory.new() # 实例化 ball_state_factory.gd
var velocity := Vector2.ZERO # 球的 速度初始为 0



func _ready() -> void:
	switch_state(State.FREEFORM) # 球的状态一开始是 “自由状态”



func switch_state(state: Ball.State) -> void:
	if current_state != null: # 如果球的当前状态 不为 null
		current_state.queue_free() # 清除当前状态
	current_state = state_factory.get_fresh_state(state) # 创建 “新” 状态
	current_state.setup(self, player_direction_area, carried) # 传入状态数据
	current_state.state_transition_requested.connect(switch_state.bind()) # 球 收到 信号
	current_state.name = "BallStateMachine"
	call_deferred("add_child", current_state)
