extends Node

# 所谓电脑自动运行，就是你预先设定好的行动，在各种（玩家）按键的状态下，通过遍历字典去实施的！！！



enum Action {LEFT, RIGHT, UP, DOWN, SHOOT, PASS} # 声明控制人物的物理按键（player的控制）

# 下面是创建字典，也把上面的 “创建” “赋予”物理按键 
const ACTIONS_MAP : Dictionary = {
	Player.ControlScheme.P1: {
		Action.LEFT: "P1_left",
		Action.RIGHT: "P1_right",
		Action.UP: "P1_up",
		Action.DOWN: "P1_down",
		Action.SHOOT: "P1_shootTheBall",
		Action.PASS: "P1_pass",
	},
	Player.ControlScheme.P2: {
		Action.LEFT: "P2_left",
		Action.RIGHT: "P2_right",
		Action.UP: "P2_up",
		Action.DOWN: "P2_down",
		Action.SHOOT: "P2_shootTheBall",
		Action.PASS: "P2_pass",
	},
}

func get_input_vector(scheme: Player.ControlScheme) -> Vector2: # 获取 玩家 按下的按键
	var map : Dictionary = ACTIONS_MAP[scheme]
	return Input.get_vector(map[Action.LEFT], map[Action.RIGHT], map[Action.UP], map[Action.DOWN])

func is_action_pressed(scheme: Player.ControlScheme, action: Action) -> bool: # 当按下 时遍历字典
	return Input.is_action_pressed(ACTIONS_MAP[scheme][action])

func is_action_just_pressed(scheme: Player.ControlScheme, action: Action) -> bool: # 当刚按下 时遍历字典
	return Input.is_action_just_pressed(ACTIONS_MAP[scheme][action])

func is_action_just_released(scheme: Player.ControlScheme, action: Action) -> bool: # 当按下后 时遍历字典
	return Input.is_action_just_released(ACTIONS_MAP[scheme][action])
	
