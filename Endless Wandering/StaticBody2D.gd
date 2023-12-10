extends StaticBody2D

var SPEED = 5
var knife_vec = Vector2(0,0)
var dir = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$existance.start()
	dir = CharacterLoader.get_node("Player").dag_dir
	if dir == 1:
		$Sprite2D.flip_h = false
	if dir == -1:
		$Sprite2D.flip_h = true
	knife_vec.x = SPEED * dir
	
func _physics_process(delta):
	move_and_collide(knife_vec)
	







func _on_area_2d_body_entered(body):
	if body.name == 'sandworm':
		body.health-=randi_range(5,15)
		print(body.health)
		queue_free()
		$hit.play()
	else:
		queue_free()


func _on_existance_timeout():
	queue_free()
