extends Node2D
var ENEMYEYE = preload("res://EyeSeer.tscn")
var ENEMYWORM = preload("res://sandworm.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	CharacterLoader.get_node("Player").emit_signal("tree_entered")
	var newEnemy = ENEMYEYE.instantiate()
	var sandworm = preload("res://sandworm.tscn").instantiate()
	var sandworm2 = preload("res://sandworm.tscn").instantiate()
	var sandworm3 = preload("res://sandworm.tscn").instantiate()
	newEnemy.position = Vector2(1430, 260)
	sandworm.position = Vector2(4620, 150)
	sandworm2.position = Vector2(4145, 150)
	sandworm3.position = Vector2(3240, 150)
	add_child(newEnemy)
	add_child(sandworm)
	add_child(sandworm2)
	add_child(sandworm3)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play()


func _on_area_2d_body_entered(body):
	pass # Replace with function body.
