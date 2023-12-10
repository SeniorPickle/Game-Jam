extends Node2D

var SEER = preload("res://EyeSeer.tscn")

signal LvlOne

func _ready():
	CharacterLoader.get_node("Player").emit_signal("tree_entered")
	var seer = SEER.instantiate()
	seer.position = $SeerSpawn.position
	add_child(seer)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play()


func _on_area_2d_body_entered(body):
	if body == CharacterLoader.get_node("Player"):
		get_tree().change_scene_to_file("res://second_level.tscn")


func _on_attack_timeout():
	$mummy/AnimatedSprite2D.play("walk")
