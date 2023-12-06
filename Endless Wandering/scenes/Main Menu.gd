extends Node2D
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _ready():
	CharacterLoader.get_node("Player").emit_signal("tree_entered")

#region buttons

func _on_options_pressed():
	$Options.show()
	$Start_Layer.hide()

func _on_button_pressed():
	$Options.hide()
	$Start_Layer.show()
	
func _on_start_game_pressed():
	PauseMenu.pausible = true
	LoadScreen.begin = true
	get_tree().change_scene_to_file('res://scenes/first_level.tscn')
	
func _on_button_2_pressed():
	$StartGame.hide()
	$Start_Layer.show()
#endregion

#region Settings Selectors

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
#endregion

func _process(delta):
	if $Menu_Sound.playing == false:
			$Menu_Sound.play()



func _on_setting_back_pressed():
	$Options.hide()
	$Start_Layer.show()
