extends Button


var frames: int = 0
var x: int
var y: int

func _process(_delta: float) -> void:
	if frames == 0:
		x = randi_range(-1, 1)
		y = randi_range(-1, 1)

	position.x += x
	position.y += y
	frames += 1
	frames = frames % 50