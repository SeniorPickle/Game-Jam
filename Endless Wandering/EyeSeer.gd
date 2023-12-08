extends CharacterBody2D


const SPEED = 80.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	var edge = false
	
	if not $floor_left.has_overlapping_bodies() or not $floor_right.has_overlapping_bodies():
		edge = false
	
	if $LeftCheck.overlaps_body(CharacterLoader.get_node("Player")) and not edge:
		$AnimationPlayer.play("moving_towards")
		$AnimatedSprite2D.flip_h = true
		velocity.x = SPEED*-1
		
	elif $RightCheck.overlaps_body(CharacterLoader.get_node("Player")) and not edge:
		velocity.x = SPEED*1
		$AnimationPlayer.play("moving_towards")
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimationPlayer.play("idleSeer")
		velocity.x = 0
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta



	move_and_slide()


func _on_area_2d_body_entered(body):
	if body == CharacterLoader.get_node("Player"):
		CharacterLoader.get_node("Player").health -= 10
