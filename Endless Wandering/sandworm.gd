extends CharacterBody2D

var direction = 1
var last_dir = 0
const SPEED:int = 50
const gravity:int = 800
var health = 50

func _ready():
	pass

func _physics_process(delta):
	if health <= 0:
		queue_free()
	if not CharacterLoader.get_node("Player").paused:
		$AnimatedSprite2D/AnimationPlayer.play()
		if not is_on_floor():
			velocity.y += gravity*delta
		velocity.x = direction*SPEED
		move_and_slide()
	elif CharacterLoader.get_node("Player").paused:
		$AnimatedSprite2D/AnimationPlayer.pause()


func _on_area_2d_body_entered(body):
	if body == CharacterLoader.get_node("Player"):
		$AnimatedSprite2D/AnimationPlayer.play("attack")
		if direction!=0:
			last_dir = direction
		direction = 0
		
func hit() -> void:
	if $Area2D.overlaps_body(CharacterLoader.get_node("Player")):
		CharacterLoader.get_node("Player").health -=10
	
func hit_end()->void:
	direction=last_dir



func _on_detect_floor_body_entered(body):
	direction*= -1
	scale.x *= -1
