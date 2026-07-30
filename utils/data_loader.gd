extends Node

var squads : Dictionary[String, Array]

func _init() -> void:

	# 把suqads.json 初始化至 josn_file中，并可阅读（FileAccess:READ）
	var json_file := FileAccess.open("res://assets/json/squads.json", FileAccess.READ)
	
	# 检查初始化的文件是否运行
	if json_file == null:
		print("could not find or load squads.json")
		
	# 初始化文本文件（.get_as_text()）至 json_text
	var json_text := json_file.get_as_text() 
	
	# 解析JSON
	var json := JSON.new()
	if json.parse(json_text) == OK:
		print("could not parse squads.json")
	
	### 以上为将json文件解析成Godot可识别的准备 ###
	
	
	
	### 以下为遍历数组并添加进最上级的  “squads” 中 ###
	
	# Json被成功解析后, 此时可通过json.data访问了
	for team in json.data:
	
		# 强制初始化 “country”（国家） 作为 string（字符串）
		# 因为squads.json字典由 “country” 与 “plyers”两部分组成，先 “country”
		var country_name := team["country"] as String
		
		# 强制初始化 “player”（玩家）至 players中，并作为 array（数组）
		var players := team["players"] as Array
		
		# 检查是否有 “键”
		if not squads.has(country_name):
			
			# 遍历的 “country” 后，剩下的皆为空，剩下的下面去遍历
			squads.set(country_name, []) # 把队伍(squads)设置为国家(country_name)	
			
		
		# 因为squads.json字典由 “country” 与 “plyers”两部分组成，再 “players”	
		for player in players:
			var fullname := player["name"] as String
			var skin := player["skin"] as Player.SkinColor
			var role := player["role"] as Player.Role
			var speed := player["speed"] as float
			var power := player["power"] as float
			
			# 初始化玩家资源至 “player_resources”中
			var player_resources := PlayerResources.new(fullname, skin, role, speed, power)
			
			# 因为此前squads已经设置成 “country_name” ， 
			# 这里要把 “player” 添加（.append()）进squads中
			squads.get(country_name).append(player_resources)
			
			# 确保每队玩家数量为 6
			assert(players.size() == 6)
		
		# 遍历一次字典后关闭它	
		json_file.close()
		
func get_squad(country: String) -> Array:
	if squads.has(country):
		return squads[country]
	return[]
