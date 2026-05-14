class_name PlayerStateData # 玩家状态数据脚本（只用来储存玩家各个状态下的 “需要调用” 的数据）

var shot_direction : Vector2

var shot_power : float


static func build() -> PlayerStateData: # build() 为静态方法（为静态时才能被调用）
	return PlayerStateData.new()

func set_shot_direction(direction: Vector2) -> PlayerStateData: # 设置 可传 “shot_direction” 的方法，并传至 “PlayerStateData”，方便调用
	shot_direction = direction
	return self # 重要！固定写法（返回数据本身）

func set_shot_power(power: float) -> PlayerStateData: # 设置 可传 “shot_power” 的方法，并传至 “PlayerStateData”，方便调用
	shot_power = power
	return self # 重要！固定写法（返回数据本身）
	
	
	
