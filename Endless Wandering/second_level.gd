extends Node2D
var sandworm = preload("res://sandworm.tscn")
var eyeseer = preload("res://EyeSeer.tscn")
var positionsWORM = [Vector2(3240, 150), Vector2(4145, 150), Vector2(4615, 150)]
var positionsEYE = [Vector2(1430, 260), Vector2(4390, 105)]
# Called when the node enters the scene tree for the first time.
func _ready():
	CharacterLoader.get_node("Player").emit_signal("tree_entered")
	for position in positionsEYE:
		var EYEINSTANCE = eyeseer.instantiate()
		EYEINSTANCE.position = position
		
		add_child(EYEINSTANCE)
	
	for position in positionsWORM:
		var WORMINSTANCE = sandworm.instantiate()
		WORMINSTANCE.position = position
		
		add_child(WORMINSTANCE)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play()


func _on_area_2d_body_entered(body):
	if body == CharacterLoader.get_node("Player"):
		get_tree().change_scene_to_file("res://second_level.tscn")
