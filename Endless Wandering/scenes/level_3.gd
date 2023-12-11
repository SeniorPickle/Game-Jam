extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	CharacterLoader.get_node("Player").emit_signal("tree_entered")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play()


func _on_area_2d_body_entered(body):
	get_tree().change_scene_to_file("res://scenes/end_screen.tscn")
