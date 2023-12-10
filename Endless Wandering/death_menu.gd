extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_respawn_pressed():
	CharacterLoader.get_node("Player")._respawn()


func _on_to_menu_pressed():
	get_tree().change_scene_to_file('res://scenes/MainMenu.tscn')
	$CanvasLayer.hide()



func _on_exit_pressed():
	get_tree().quit()
