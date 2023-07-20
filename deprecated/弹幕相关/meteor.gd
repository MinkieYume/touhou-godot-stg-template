extends Node2D

var meteor_length = 300 #流星尾巴长度
var meteor_width = 8 #流星头部宽度

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	var range = atan(-1)
	var wx = position.x + (cos(range) * meteor_length)
	var wy = position.y + (sin(range) * meteor_length)
	var points = [Vector2(position.x - (meteor_width * scale.x / 2), position.y - (meteor_width * scale.y)), Vector2(position.x + (meteor_width * scale.x), position.y + (meteor_width * scale.y / 2)), Vector2(wx, wy)]
	draw_polygon(points, [Color(255, 255, 255, 0.5)])
