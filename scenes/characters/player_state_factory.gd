class_name PlayerStateFactory

var states : Dictionary

func _init() -> void: # 添加状态字典（人物的各种状态）
	states = {
		Player.State.MOVING: PlayerStateMoving,
		Player.State.TACKLING: PlayerStateTackling,
		Player.State.RECOVERING: PlayerStateRecovering,
	}

func get_fresh_state(state: Player.State) -> PlayerState: # 传入一个玩家状态，并返回一个玩家状态（这里是各种状态：包括 “铲球”、“移动” 等）
	assert(states.has(state), "state dosen't exist!") # assert(1, 2)方法是: 如果判断 1 是 “否”， 则 返回 “2”（“2”可以是字符串）
	return states.get(state).new() # 上面assert(1, 2)，已经判断 “1” 是 否， 就返回（return）， 获取（.get()） 从字典中获取 类，创建新实例（.new()）
	# 可以通过每次使用“player_state_factory”， 请求一个新的状态对象
