extends Node2D


@export var showing : bool = false
@export var pausible:bool = false

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if showing and pausible:
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
	$layer_main.hide()
	showing = false


func _on_options_pressed():
	$Options.show()
	
func _on_graphics_pressed():
	$Options/MarginContainer/VBoxContainer3/SoundSettings.hide()
	$Options/MarginContainer/VBoxContainer3/GraphicSettings.show()
	$Options/MarginContainer/VBoxContainer3/Other.hide()

func _on_sound_pressed():
	$Options/MarginContainer/VBoxContainer3/SoundSettings.show()
	$Options/MarginContainer/VBoxContainer3/GraphicSettings.hide()
	$Options/MarginContainer/VBoxContainer3/Other.hide()

func _on_other_pressed():
	$Options/MarginContainer/VBoxContainer3/SoundSettings.hide()
	$Options/MarginContainer/VBoxContainer3/GraphicSettings.hide()
	$Options/MarginContainer/VBoxContainer3/Other.show()



func _on_back_opt_pressed():
	# TODO: Move Buttons To the Actual Settings Script, and make it the settings screen
	$Options.hide()



func _on_exmenu_pressed():
	pausible = false
	get_tree().change_scene_to_file('res://scenes/MainMenu.tscn')


func _on_exgm_pressed():
	get_tree().quit()
