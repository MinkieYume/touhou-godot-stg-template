class_name Util
extends Node

#通用功能函数库
static func scan(path:String) -> Array:
	var file_name := ""
	var files := []
	# Standard
	var dir = DirAccess.open(path)
	if dir != OK:
		print("Failed to open:"+path)
	else:
		dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
		file_name = dir.get_next()
		while file_name!="":
			if dir.current_is_dir():
				var sub_path = path+"/"+file_name
				files += scan(sub_path)
			else:
				var name := path+"/"+file_name
				files.push_back(name)
			file_name = dir.get_next()
		dir.list_dir_end()
	return files

static func get_line_points(v1:Vector2,v2:Vector2) -> Array:
	#返回两个向量组成直线的所有整数点
	v1 = v1.ceil()
	v2 = v2.ceil()
	var points = []
	var line_range = (v2 - v1)
	if line_range.x == 0:
		print(line_range)
		#直线垂直于X轴的情况
		for y in range(abs(line_range.y)):
			var point = Vector2(v2.x,y+v1.y)
			points.append(point)
	else:
		#直线不垂直于X轴的情况
		var k = (v2.y-v1.y) / (v2.x-v1.x)
		var b = v2.y-k*v2.x
		for x in range(abs(line_range.x)):
			for y in range(abs(line_range.x)):
				var point = Vector2(x+v1.x,y+v1.y)
				var distance = abs(k*point.x-point.y+b)/\
				sqrt(1+pow(k,2))
				if distance == 0:
					points.append(point)
	
	return points
