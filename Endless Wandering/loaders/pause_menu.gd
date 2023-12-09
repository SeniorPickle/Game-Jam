extends Node2D


@export var showing : bool = false
@export var pausible:bool = false


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if showing and pausible and not Options.top_layer:
			$layer_main.hide()
			showing = false
			CharacterLoader.get_node("Player").paused = false

		elif not showing and pausible:
			$layer_main.show()
			showing = true
			CharacterLoader.get_node("Player").paused = true
	if showing and not pausible:
		$layer_main.hide()
		showing = false




func _on_unpause_pressed():
	CharacterLoader.get_node("Player").paused = false
	$layer_main.hide()
	showing = false


func _on_options_pressed():
	Options.top_layer = true
	Options.show()
	
func _on_exmenu_pressed():
	pausible = false
	get_tree().change_scene_to_file('res://scenes/MainMenu.tscn')


func _on_exgm_pressed():
	get_tree().quit()
