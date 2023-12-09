extends StaticBody2D


const SPEED = 2.0
const JUMP_VELOCITY = -400.0
var dir = 0
var char_veloc = Vector2(0, 0)



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	$AnimationPlayer.play()
	if CharacterLoader.get_node("Player").paused == false:
		var edge = false
		
		if not $floor_left.has_overlapping_bodies() or not $floor_right.has_overlapping_bodies():
			edge = false
		
		if $LeftCheck.overlaps_body(CharacterLoader.get_node("Player")) and not edge:
			$AnimationPlayer.play("moving_towards")
			$AnimatedSprite2D.flip_h = true
			char_veloc.x = SPEED*-1
			dir = 1
			
		elif $RightCheck.overlaps_body(CharacterLoader.get_node("Player")) and not edge:
			char_veloc.x = SPEED*1
			dir = -1
			$AnimationPlayer.play("moving_towards")
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimationPlayer.play("idleSeer")
			char_veloc.x = 0
			
		# Add the gravity.

		move_and_collide(char_veloc)
	else:
		$AnimationPlayer.pause()


func _on_area_2d_body_entered(body):
	if body == CharacterLoader.get_node("Player"):
		CharacterLoader.get_node("Player").health -= 10
		position.x += 40*dir
