extends CanvasLayer

signal submit_coin(coin_name: String)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("submit_input"):
		submit_coin.emit(%CoinName.text)