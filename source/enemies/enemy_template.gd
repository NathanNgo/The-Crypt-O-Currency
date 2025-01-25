extends Node2D

enum EnemyTypes {
	GOBLIN,
	OGRE,
	GHOST,
}

@export var default_enemy_sprite: Texture2D

var enemy_variants = [
	{
		"enemy_type": EnemyTypes.GOBLIN,
		"enemy_class_name": "Goblin",
		"enemy_health": 10,
		"enemy_attack": 4,
		"enemy_cost": 2
	},
	{
		"enemy_type": EnemyTypes.OGRE,
		"enemy_class_name": "Ogre",
		"enemy_health": 24,
		"enemy_attack": 10,
		"enemy_cost": 5
	},
	{
		"enemy_type": EnemyTypes.GHOST,
		"enemy_class_name": "Ghost",
		"enemy_health": 10,
		"enemy_attack": 2,
		"enemy_cost": 1
	},
]


var health: int
var attack: int
var enemy_type: int
var enemy_cost: int


func _ready() -> void:
	var enemy_variant = enemy_variants[randi_range(0, enemy_variants.size() - 1)]

	health = enemy_variant["enemy_health"]
	attack = enemy_variant["enemy_attack"]
	enemy_type = enemy_variant["enemy_type"]
	enemy_cost = enemy_variant["enemy_cost"]

	%EnemySprite.texture = default_enemy_sprite