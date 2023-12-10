extends Node2D
var ENEMY = preload("res://EyeSeer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	CharacterLoader.get_node("Player").emit_signal("tree_entered")
	var newEnemy = ENEMY.instantiate()
	newEnemy.position = Vector2(1470, 260)
	add_child(newEnemy)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play()


func _on_area_2d_body_entered(body):
	pass # Replace with function body.
