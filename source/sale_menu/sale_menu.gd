extends Node2D

signal sale_complete(coin_bought: int, coin_value: int)

@export var hero_template: PackedScene
@export var slogan_button: PackedScene

var slogan_amount: int = 0
var trust: int = 0
var coin_name: String = "Etherium":
	set(value):
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
	%SaleTimer.timeout.connect(_on_sale_timer_timeout)
	%SloganSpawnTimer.timeout.connect(_on_spawn_timer_timeout)


func generate_heroes() -> void:
	var current_heroes: Array[Node2D] = []
	for hero_index in 4:
		var hero = hero_template.instantiate()
		current_heroes.append(hero)
		%HeroContainer.add_child(hero)

	Heroes.current_heroes = current_heroes


func remove_heroes() -> void:
	for hero in Heroes.current_heroes:
		%HeroContainer.remove_child(hero)


func setup() -> void:
	generate_heroes()
	%SaleTimer.start()
	%SloganSpawnTimer.start()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click_slogan"):
		trust -= 5


func _on_sale_timer_timeout() -> void:
	var value = trust * randi_range(2, 4)
	sale_complete.emit(value)

	# Play cackle


func _on_spawn_timer_timeout() -> void:
	var time = randf_range(0.0, 1.0)
	%SloganSpawnTimer.start(time)

	if slogan_amount > 10:
		return

	var slogan = slogan_button.instantiate()
	var slogan_text = slogans[randi_range(0, slogans.size() - 1)]
	slogan.set_text(slogan_text)
	slogan.position.x += randi_range(100, 1052)
	slogan.position.y += randi_range(100, 548)
	slogan.pressed.connect(_on_mouse_clicked.bind(slogan))
	%SloganContainer.add_child(slogan)
	slogan_amount += 1


func _on_mouse_clicked(slogan_button_input: Button) -> void:
	trust += 15
	slogan_button_input.queue_free()
	slogan_amount -= 1