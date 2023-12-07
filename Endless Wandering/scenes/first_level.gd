extends Node2D


signal LvlOne

func _ready():
	CharacterLoader.get_node("Player").emit_signal("tree_entered")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play()


func _on_area_2d_body_entered(body):
	pass # Replace with function body.


func _on_attack_timeout():
	$mummy/AnimatedSprite2D.play("walk")
