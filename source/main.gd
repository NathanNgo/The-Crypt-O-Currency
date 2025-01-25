extends Node

@export var hero_template: PackedScene
@export var enemy_template: PackedScene
@export var slogan_button: PackedScene

var coin_value: int = 0
var time: int = 1
var sale_pressure: int = 0
var real_money: int = 0
var heroes_slain: int = 0
var dungeon_rooms: Array = []
var current_dungeon_room: int = 0
var slogan_amount: int = 0
var hype: int = 0
var sale_phase: bool = false
var stock_dumped: bool = false
var plot
var coin_name: String = "Etherium":
	set(value):
		if value == "":
			value = "Etherium"
		for slogan_with_coin_name in slogans_with_coin_names:
			slogans.append(slogan_with_coin_name % value)

var slogans = [
	"Guaranteed growth!",
	"No rug!",
	"Invest today!",
	"Zero risk!",
	"Unshackle yourself from the gold standard!",
	"Banish all FUD!",
	"What an opportunity!",
	"It’s passive income!",
	"You’ll thank yourself later!",
	"Easy to trade!",
	"More reliable than cash!",
	"Trust me bro!",
	"To the moon!",
	"Incredible value!",
	"Limited time only!",
	"You’d be stupid NOT to buy!",
	"It’s magic money!",
	"It’ll last forever!",
	"It’s no passing craze!",
	"Real economists trust ghosts!",
	"More profit than you can handle!",
	"Look at all the advantages!",
	"It’s free money!",
	"It’s the future!",
	"Get in on the ground floor!",
	"Tell your friends!",
	"See the light!",
	"What’s there to worry about?!",
	"Tested and proven!",
	"Nothing to lose!",
	"Retire early!",
	"Look at the liquidity pool!",
]

var slogans_with_coin_names = [
	"%s got my kids through college!",
	"%s made me who I am!",
	"Other coins may be scams - but not %s!",
]


func _ready() -> void:
	%CoinCreation.submit_coin.connect(_on_submit_coin)

	%CoinCreation.show()

	%SaleTimer.timeout.connect(_on_sale_timer_timeout)
	%SloganSpawnTimer.timeout.connect(_on_slogan_spawn_timer_timeout)
	%HeroAttackTimer.timeout.connect(_on_hero_attack_timer_timeout)
	%EnemyAttackTimer.timeout.connect(_on_enemy_attack_timer_timeout)
	%RandomValueChangeTimer.timeout.connect(_on_random_value_change_timer_timeout)

	%HypeAmount.set_text(str(hype))
	%ValueAmount.set_text(str(coin_value))
	%Graph2D.hide()
	plot = %Graph2D.add_plot_item()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click_slogan"):
		if not sale_phase:
			return
		hype -= 5
		%HypeAmount.set_text(str(hype))


func generate_heroes() -> void:
	for hero_index in 4:
		var hero = hero_template.instantiate()
		%HeroContainer.add_child(hero)


func start_sale() -> void:
	generate_heroes()
	%SaleTimer.start()
	%SloganSpawnTimer.start()


func start_dungeon() -> void:
	%RandomValueChangeTimer.start(1)
	generate_dungeons()
	load_dungeon_room()


func load_dungeon_room() -> void:
	if current_dungeon_room >= dungeon_rooms.size():
		game_lost()
		return

	for hero in %HeroContainer.get_children():
		hero.set_alive()

	var enemies = dungeon_rooms[current_dungeon_room]
	for enemy in enemies:
		%EnemyContainer.add_child(enemy)
	
	%HeroAttackTimer.start(2)
	%EnemyAttackTimer.start(3)
	print("Loading Dungeon %d" % current_dungeon_room)


func generate_enemies() -> Array[Node2D]:
	var enemies: Array[Node2D] = []
	for enemy_index in randi_range(2, 3):
		enemies.append(enemy_template.instantiate())

	return enemies


func generate_dungeons() -> void:
	for room_index in randi_range(2, 4):
		dungeon_rooms.append(generate_enemies())


func game_lost() -> void:
	# Show lost screen.
	print("Game lost")
	real_money = 0
	reset_game()


func game_won() -> void:
	print("Game won")
	heroes_slain += %HeroContainer.get_children().size()
	reset_game()


func reset_game() -> void:
	%EnemyAttackTimer.stop()
	%HeroAttackTimer.stop()
	%RandomValueChangeTimer.stop()
	pass


func set_coin_value(value: int) -> void:
	if value > coin_value:
		possible_hero_sell()

	coin_value = value
	%ValueAmount.text = str(coin_value)
	plot.add_point(Vector2(time, coin_value))
	time += 1
	# Set it in the graph


func possible_hero_sell() -> void:
	if stock_dumped:
		return

	sale_pressure += randi_range(1, 8)
	
	if sale_pressure < 100:
		return

	print("Heroes dumped")
	set_coin_value(0)
	stock_dumped = true

	for hero in %HeroContainer.get_children():
		hero.equipment_quality = HeroTemplate.EquipmentQuality.GOLD
		hero.attack = hero.attack * 2


func _on_sale_timer_timeout() -> void:
	set_coin_value(hype * randi_range(2, 4))
	sale_phase = false
	for slogan in %SloganContainer.get_children():
		slogan.queue_free()
	%Graph2D.show()
	
	# Play cackle
	start_dungeon()


func _on_slogan_spawn_timer_timeout() -> void:
	if not sale_phase:
		return

	var time = randf_range(0.0, 1.0)
	%SloganSpawnTimer.start(time)

	if slogan_amount > 10:
		return

	var slogan = slogan_button.instantiate()
	var slogan_text = slogans[randi_range(0, slogans.size() - 1)]
	slogan.set_text(slogan_text)
	slogan.position.x += randi_range(200, 1720)
	slogan.position.y += randi_range(100, 580)
	slogan.pressed.connect(_on_mouse_clicked.bind(slogan))
	%SloganContainer.add_child(slogan)
	slogan_amount += 1


func _on_mouse_clicked(slogan_button_input: CharacterBody2D) -> void:
	hype += 15
	slogan_button_input.queue_free()
	slogan_amount -= 1
	%HypeAmount.set_text(str(hype))


func _on_submit_coin(coin_name_input: String) -> void:
	sale_phase = true
	coin_name = coin_name_input
	%CoinCreation.hide()
	start_sale()


func _on_hero_attack_timer_timeout() -> void:
	print("Heroes attacking")
	var total_attack = 0
	var enemies_remaining = false

	for hero in %HeroContainer.get_children():
		if hero.health > 0:
			total_attack += hero.attack

	var first_enemy = %EnemyContainer.get_child(0)
	first_enemy.health -= total_attack

	if first_enemy.health <= 0:
		print("Enemy Killed!")
		var random_amount = randi_range(-30, 70) * 2 * first_enemy.enemy_cost
		set_coin_value(coin_value + random_amount)
		first_enemy.queue_free()

	for enemy in %EnemyContainer.get_children():
		if enemy.health > 0:
			enemies_remaining = true

	if not enemies_remaining:
		current_dungeon_room += 1
		print("All enemies dead")
		load_dungeon_room()
		return


func _on_enemy_attack_timer_timeout() -> void:
	print("Enemies attacking")
	var total_attack = 0
	var heroes_remaining = false

	for enemy in %EnemyContainer.get_children():
		total_attack += enemy.attack

	for hero in %HeroContainer.get_children():
		if hero.health <= 0:
			continue

		hero.health -= total_attack

		if hero.health <= 0:
			hero.set_dead()
		
		break

	for hero in %HeroContainer.get_children():
		if hero.health > 0:
			heroes_remaining = true

	if not heroes_remaining:
		print("All heroes dead")
		game_won()
		return

	%EnemyAttackTimer.start(3)
	%HeroAttackTimer.start(2)


func _on_random_value_change_timer_timeout() -> void:
	set_coin_value(coin_value + randi_range(-3, 3) * 10)
	%RandomValueChangeTimer.start(1)


func _on_stock_dump_button_pressed() -> void:
	if stock_dumped:
		return

	real_money += coin_value * 1000

	for hero in %HeroContainer.get_children():
		hero.quipment_quality = HeroTemplate.EquipmentQuality.WOOD
		hero.attack = 1
