extends CharacterBody2D

@export var SPEED: int
@export var JUMP_VELOCITY: int
@export var gravity: int
@export var MAX_FALL_SPEED: int
@export var paused: bool = false
func _ready():
	pass

func _physics_process(delta):
	# Add the gravity only when the character is not on the floor.
	if not is_on_floor():
		velocity.y += gravity * delta
		$AnimatedSprite2D.play('new_animation')
		$ground_poly.disabled = true
		$air_poly.disabled = false
	else:
		$Camera2D.position_smoothing_speed = 5
		$ground_poly.disabled = false
		$air_poly.disabled = true
		velocity.y = 0  # Reset vertical velocity when on the floor.

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY  # Use a negative value for upward velocity.
		velocity.y = min(velocity.y, MAX_FALL_SPEED)
	if Input.is_action_just_pressed("left"):
		$AnimatedSprite2D.flip_h = true
	if Input.is_action_just_pressed("right"):
		$AnimatedSprite2D.flip_h = false

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if not paused:
		if direction:
			velocity.x = direction * SPEED
			if is_on_floor():
				$AnimatedSprite2D.play('default')
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_floor():
				$AnimatedSprite2D.animation = 'default'
				$AnimatedSprite2D.frame = 0
				$AnimatedSprite2D.pause()

		# Update the character's position based on velocity.
	move_and_slide()

func _on_death_colider_body_entered(body):
	position.x = 50
	position.y = 150
	$Camera2D.reset_smoothing()



func _on_tree_entered():
	
	if get_tree() != null and get_tree().current_scene != null:
		var current_scene_name = get_tree().current_scene.name
		print("Current Scene: ", current_scene_name)
		if current_scene_name != "MainMenu":
			paused = true
		if current_scene_name == "first_level":
			position.y = 50
			position.x = 150
			$Camera2D.reset_smoothing()
			show()
			print("Character Visible and moved to", position)
		elif current_scene_name == "MainMenu":
			hide()
			print("Character Hidden")
		else:
			show()
			print("Character Visible")
	else:
		print("Invalid SceneTree or current scene.")


func _on_step_sfx_timeout():
	if (velocity.x < 0  or velocity.x > 0) and velocity.y==0 and get_tree().current_scene.name != 'MainMenu':
		if $AudioStreamPlayer2D.playing == false:
			$AudioStreamPlayer2D.play()
