class_name PlayerStateFactory

var states : Dictionary

func _init() -> void: # 添加状态字典（人物的各种状态）
	states = {
		Player.State.MOVING: PlayerStateMoving,
		Player.State.TACKLING: PlayerStateTackling,
	}

func get_fresh_state(state: Player.State) -> PlayerState:
	assert(states.has(state), "state dosen't exist!")
	return states.get(state).new()