extends Node2D
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _ready():
	CharacterLoader.get_node("Player").emit_signal("tree_entered")
	CharacterLoader.get_node("Player").paused = false

func _physics_process(delta):
	if $Menu_Sound.playing == false:
		$Menu_Sound.play()
		
	if not Options.top_layer:
		$Start_Layer.show()

func _on_options_pressed():
	Options.top_layer = true
	Options.show()
	$Start_Layer.hide()
		
func _on_start_game_pressed():
	PauseMenu.pausible = true
	LoadScreen.begin = true
	get_tree().change_scene_to_file('res://scenes/first_level.tscn')
	



func _on_exit_pressed():
	get_tree().quit()
