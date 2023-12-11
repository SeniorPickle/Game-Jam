extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/Camera2D.make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_lvl_1_pressed():
	PauseMenu.pausible = true
	LoadScreen.begin = true
	get_tree().change_scene_to_file('res://scenes/first_level.tscn')


func _on_lvl_2_pressed():
	PauseMenu.pausible = true
	LoadScreen.begin = true
	get_tree().change_scene_to_file("res://second_level.tscn")


func _on_lv_3_pressed():
	PauseMenu.pausible = true
	LoadScreen.begin = true
	get_tree().change_scene_to_file("res://scenes/level_3.tscn")


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
