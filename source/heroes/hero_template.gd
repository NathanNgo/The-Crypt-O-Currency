class_name HeroTemplate extends Node2D

enum EquipmentQuality {
	WOOD,
	IRON,
	GOLD
}

enum EquipmentType {
	SWORD,
	SHIELD,
	BOW,
	QUIVER,
	BOOK,
	HAT,
	STAFF,
	SCROLL
}

enum HeroTypes {
	FIGHTER,
	ARCHER,
	WIZARD,
	MONK
}

@export var default_hero_sprite: Texture2D

var hero_variants = [
	{
		"hero_type": HeroTypes.FIGHTER,
		"hero_class_name": "Fighter",
		"hero_health": 20,
		"hero_attack": 2,
		"equipment": [EquipmentType.SWORD, EquipmentType.SHIELD],
		"equipment_quality": EquipmentQuality.IRON
	},
	{
		"hero_type": HeroTypes.ARCHER,
		"hero_class_name": "Archer",
		"hero_health": 12,
		"hero_attack": 4,
		"equipment": [EquipmentType.BOW, EquipmentType.QUIVER],
		"equipment_quality": EquipmentQuality.IRON
	},
	{
		"hero_type": HeroTypes.WIZARD,
		"hero_class_name": "Wizard",
		"hero_health": 8,
		"hero_attack": 6,
		"equipment": [EquipmentType.BOOK, EquipmentType.HAT],
		"equipment_quality": EquipmentQuality.IRON
	},
	{
		"hero_type": HeroTypes.MONK,
		"hero_class_name": "Monk",
		"hero_health": 15,
		"hero_attack": 3,
		"equipment": [EquipmentType.STAFF, EquipmentType.SCROLL],
		"equipment_quality": EquipmentQuality.IRON
	},
]


var health: int
var health_max: int
var attack: int
var hero_type: int
var hero_alive = true

var equipment: Array
var equipment_quality: EquipmentQuality


func _ready() -> void:
	var hero_variant = hero_variants[randi_range(0, hero_variants.size() - 1)]

	health = hero_variant["hero_health"]
	health_max = hero_variant["hero_health"]
	attack = hero_variant["hero_attack"]
	hero_type = hero_variant["hero_type"]
	equipment = hero_variant["equipment"]
	equipment_quality = hero_variant["equipment_quality"]
	%HeroSprite.texture = default_hero_sprite


func set_dead():
	hide()


func set_alive():
	health = health_max
	show()