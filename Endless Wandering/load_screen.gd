extends Node2D

@export var begin: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if begin:
		$CanvasLayer.show()
		$CanvasLayer/ProgressBar.value += 1
		if $CanvasLayer/ProgressBar.value == $CanvasLayer/ProgressBar.max_value:
			$CanvasLayer.hide()
			$CanvasLayer/ProgressBar.value = 0
			CharacterLoader.get_node("Player").paused = false
			begin = false
