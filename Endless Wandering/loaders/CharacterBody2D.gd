extends CharacterBody2D

enum PlayerStates {DEFAULT, HOOKED}
enum HookStates {NONE, EXTEND, RETRACT_TO_PLAYER}


@export var SPEED: int
@export var JUMP_VELOCITY: int
@export var gravity: int
@export var MAX_FALL_SPEED: int
@export var paused: bool = false
const HOOK_MAX_LENGTH := 200.0
const HOOK_SPEED := 800.0
const PLAYER_HOOK_SPEED := 600.0
const ACCELERATION := 1_500.0

var hook_direction: Vector2
var player_state: PlayerStates = PlayerStates.DEFAULT
var hook_state: HookStates = HookStates.NONE

@onready var hook := $Hook
@onready var hook_shape := $Hook/CollisionShape2D
@onready var line := $Line2D

var jumps := 0
func _ready():
	pass

func _physics_process(delta):
	match player_state:
		PlayerStates.DEFAULT:
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
				player_state = PlayerStates.DEFAULT
				hook_state = HookStates.RETRACT_TO_PLAYER
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
		PlayerStates.HOOKED:
			# Calculate swing trajectory
			velocity.y += gravity * delta
			var hook_to_player = global_position - hook.global_position
			var perpendicular = Vector2(-hook_to_player.y, hook_to_player.x).normalized()
			var swing_influence = Input.get_action_strength("right") - Input.get_action_strength("left")
			var swing_influence_factor = 0.1  # Adjust as needed
			velocity += perpendicular * (PLAYER_HOOK_SPEED * swing_influence * swing_influence_factor)
			var air_resistance = 0.95  # Adjust as needed
			velocity *= air_resistance
			var player_above_hook = dot(hook_to_player.normalized(), Vector2(0, -1)) > 0
			if player_above_hook:
				perpendicular = -perpendicular
			var max_velocity = 1000.0  # Adjust as needed
			velocity = velocity.limit_length(max_velocity)
			
			velocity.x += swing_influence * swing_influence_factor
			var collision := move_and_collide(velocity * delta)
			
			if collision:
				player_state = PlayerStates.DEFAULT
				hide_hook()
			elif global_position.distance_to(hook.global_position) <= PLAYER_HOOK_SPEED * delta:
				global_position = hook.global_position
				player_state = PlayerStates.DEFAULT
				hide_hook()
		
	match hook_state:
		HookStates.EXTEND:
			hook.global_position += hook_direction * HOOK_SPEED * delta
			if hook.global_position.distance_to(global_position) >= HOOK_MAX_LENGTH:
				hook_state = HookStates.RETRACT_TO_PLAYER
				hook_shape.set_disabled.call_deferred(true)
		HookStates.RETRACT_TO_PLAYER:
			hook.global_position += hook.global_position.direction_to(global_position) * HOOK_SPEED * delta
			if hook.global_position.distance_to(global_position) <= HOOK_SPEED * delta:
				hook_state = HookStates.NONE
				hide_hook()
				
	if hook.visible:
		line.points[1] = to_local(hook.global_position)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and hook_state == HookStates.NONE:
		hook.global_position = global_position
		hook_state = HookStates.EXTEND
		hook_direction = get_local_mouse_position().normalized()
		hook.show()
		line.show()
		hook_shape.disabled = false


func _on_hook_body_entered(_body: Node2D) -> void:
	player_state = PlayerStates.HOOKED
	velocity = global_position.direction_to(hook.global_position) * PLAYER_HOOK_SPEED
	hook_state = HookStates.NONE
	hook_shape.set_disabled.call_deferred(true)


func hide_hook() -> void:
	hook.hide()
	line.hide()
	hook_shape.set_disabled.call_deferred(true)


func _on_death_colider_body_entered(body):
	position.x = 50
	position.y = 150
	hide_hook()
	hook_state = HookStates.RETRACT_TO_PLAYER
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


