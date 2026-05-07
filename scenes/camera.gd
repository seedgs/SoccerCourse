class_name Camera

extends Camera2D

const DISTANCE_TARGET := 10.0

const SMOOTHING_BALL_CARRIED := 2.0

const SMOOTHING_BALL_DEFAULT := 8.0
 
@export var ball : Ball


func _process(_delta: float) -> void:

	 # 持球者 “不为” null，既持球者 为 玩家
	if ball.carried != null:

		# 此时摄像机的位置 为 玩家的位置（跟踪玩家）
		# 但是！ 由于现在摄像机跟踪玩家移动而移动，此时玩家在摄像机正中央！
		# 或许你需要偏移一下摄像机，以达到更好的效果
		# 此时你需要 以一个 “基准点” 去偏移数值，但是你此时摄像机是跟随玩家移动的
		# “基准点” 又需要一个固定值，所以 “ball.carried,heading” 提供了一个动态的 “固定点”
		# 你的偏移量数值可以 以 这个 动态的固定点去 为 基准！
		# 其实 “ball.carried.heading” 也就是玩家的朝向！
		position = ball.carried.position + ball.carried.heading * DISTANCE_TARGET
		position_smoothing_speed = SMOOTHING_BALL_CARRIED # “position_smoothing_speed” 相机平滑
	else:
		position = ball.position
		position_smoothing_speed = SMOOTHING_BALL_DEFAULT
