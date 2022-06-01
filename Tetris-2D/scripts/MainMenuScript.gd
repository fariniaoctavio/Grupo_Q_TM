extends Control



func _on_SinglePlayerButton_pressed():
	get_tree().change_scene("res://Tetris.tscn")


func _on_MultiPlayerButton_pressed():
	get_tree().change_scene("res://Lobby.tscn")
