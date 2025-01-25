extends CharacterBody2D

signal pressed

@export var speed = 200

var frames: int = 0
var x: int
var y: int
var direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	%SloganButton.pressed.connect(_on_button_pressed)


func _process(_delta: float) -> void:
	if frames == 0:
		direction.x = randi_range(-1, 1)
		direction.y = randi_range(-1, 1)
		direction = direction.normalized()

	frames += 1
	frames = frames % 50

	velocity = speed * direction
	move_and_slide()


func set_text(text: String) -> void:
	%SloganButton.text = text
	var text_size_x = %SloganButton.get_theme_font("font").get_string_size(text).x
	var new_shape = %CollisionShape2D.shape.duplicate()
	new_shape.set_size(Vector2(text_size_x + 10, new_shape.size.y))
	%CollisionShape2D.shape = new_shape
	%SloganButton.size.x = text_size_x
	$CollisionShape2D.position.x += (text_size_x + 10)/ 2.0

	# %CollisionShape2D.position = %SloganButton.position

func _on_button_pressed() -> void:
	pressed.emit()