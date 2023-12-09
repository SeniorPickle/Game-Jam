extends CanvasLayer

var top_layer = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_graphics_pressed():
	$MarginContainer/VBoxContainer3/SoundSettings.hide()
	$MarginContainer/VBoxContainer3/GraphicSettings.show()
	$MarginContainer/VBoxContainer3/Other.hide()

func _on_sound_pressed():
	$MarginContainer/VBoxContainer3/SoundSettings.show()
	$MarginContainer/VBoxContainer3/GraphicSettings.hide()
	$MarginContainer/VBoxContainer3/Other.hide()

func _on_other_pressed():
	$MarginContainer/VBoxContainer3/SoundSettings.hide()
	$MarginContainer/VBoxContainer3/GraphicSettings.hide()
	$MarginContainer/VBoxContainer3/Other.show()


func _on_back_opt_pressed():
	top_layer = false
	hide()
