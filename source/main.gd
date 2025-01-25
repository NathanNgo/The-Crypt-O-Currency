extends Node

var coin_name: String
var coin_bought: int
var coin_value: int

func _ready() -> void:
	%CoinCreation.submit_coin.connect(_on_submit_coin)
	%SaleMenu.sale_complete.connect(_on_sale_complete)


	%SplashScreen.hide()
	%SaleMenu.hide()
	%Dungeon.hide()
	%CoinCreation.hide()
	%CoinCreation.show()


func _on_submit_coin(coin_name_input: String) -> void:
	coin_name = coin_name_input
	%CoinCreation.hide()
	%SaleMenu.show()
	%SaleMenu.setup()
	%SaleMenu.coin_name = coin_name


func _on_sale_complete(coin_bought_input: int, coin_value_input: int) -> void:
	coin_bought = coin_bought_input
	coin_value = coin_value_input
	%SaleMenu.hide()
	%Dungeon.show()