extends CharacterBody2D

enum PlayerStates {DEFAULT, HOOKED, SWUNG}
enum HookStates {NONE, EXTEND, RETRACT_TO_PLAYER, HOOKED}

var LEVEL = 0

@export var health: int = 100
@export var SPEED: int
@export var JUMP_VELOCITY: int
@export var gravity: int
@export var MAX_FALL_SPEED: int
@export var paused: bool = false
@export var HOOK_LENGTH: int = 0 
const HOOK_MAX_LENGTH := 200.0
const HOOK_SPEED := 700.0
const PLAYER_HOOK_SPEED := 300.0
const ACCELERATION := 1_500.0

var hook_direction: Vector2
var player_state: PlayerStates = PlayerStates.DEFAULT
var hook_state: HookStates = HookStates.NONE
var collision: bool = false
@onready var hook := $Hook
@onready var hook_shape := $Hook/CollisionShape2D
@onready var line := $Line2D

var jumps := 0
func _ready():
	pass

func _physics_process(delta):
	$Camera2D/hud/ProgressBar.value = health
	if health <= 0:
		hide()
		paused = true
	print(player_state, hook_state)
	
	
	match player_state:
		PlayerStates.DEFAULT:
			handle_gravity(delta)
			print('Default')
			movement_logic(delta)
		PlayerStates.HOOKED:
			swing_logic(delta)
		PlayerStates.SWUNG:
			swung_logic(delta)
			
	move_and_slide()
	
	match hook_state:
		HookStates.EXTEND:
			extend_hook_logic(delta)
		HookStates.RETRACT_TO_PLAYER:
			retract_hook_logic(delta)
	
	if hook.visible:
		line.points[1] = to_local(hook.global_position)

func swung_logic(delta):
	var dampening = 0.99
	velocity *= dampening
	if is_on_floor():
		player_state = PlayerStates.DEFAULT

func handle_gravity(delta):
	if not is_on_floor() and player_state == PlayerStates.DEFAULT:
		velocity.y += gravity * delta
		$AnimatedSprite2D.play('new_animation')
	else:
		$Camera2D.position_smoothing_speed = 5
		velocity.y = 0  # Reset vertical velocity when on the floor.
		
func movement_logic(delta):
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not paused:
		velocity.y = JUMP_VELOCITY  # Use a negative value for upward velocity.
		velocity.y = min(velocity.y, MAX_FALL_SPEED)
		player_state = PlayerStates.DEFAULT



	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	print(direction)
	if paused and is_on_floor():
		velocity.x = 0
		$AnimatedSprite2D.animation = 'default'
		$AnimatedSprite2D.frame = 0
		$AnimatedSprite2D.pause()
	elif paused and not is_on_floor():
		velocity.x = 0
		velocity.y = 0
		$AnimatedSprite2D.animation = 'new_animation'
		$AnimatedSprite2D.frame = 0
		$AnimatedSprite2D.pause()
	if not paused:
		if Input.is_action_just_pressed("left"):
			$AnimatedSprite2D.flip_h = true
		if Input.is_action_just_pressed("right"):
			$AnimatedSprite2D.flip_h = false
		if direction:
			velocity.x = direction * SPEED
			if is_on_floor():
				$AnimatedSprite2D.play('default')
		else:
			if hook_state == HookStates.NONE:
				velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_floor():
				$AnimatedSprite2D.animation = 'default'
				$AnimatedSprite2D.frame = 0
				$AnimatedSprite2D.pause()
	
func swing_logic(delta):
	var hook_to_player = global_position - hook.global_position
	var hook_to_player_length = hook_to_player.length()
	var perpendicular = Vector2(-hook_to_player.y, hook_to_player.x).normalized()
	var swing_pull = 60
	if not is_on_floor():
		$AnimatedSprite2D.play('new_animation')
	if hook_to_player_length > HOOK_MAX_LENGTH and hook_state == HookStates.EXTEND:
		# Player missed the hook, retract it
		player_state = PlayerStates.DEFAULT
		hook_state = HookStates.RETRACT_TO_PLAYER
		
	elif hook_to_player_length > HOOK_MAX_LENGTH and hook_state == HookStates.HOOKED:
		player_state = PlayerStates.SWUNG
		hook_state = HookStates.RETRACT_TO_PLAYER
		
	elif hook_to_player_length < HOOK_MAX_LENGTH and hook_state == HookStates.HOOKED:
		var swing_gravity = 800
		velocity.y += swing_gravity * delta
		
		var target_swing_direction: Vector2
		var current_swing_direction = velocity.normalized()
		var dot_product = current_swing_direction.dot(target_swing_direction)
		
		var swing_influence = Input.get_action_strength("left") - Input.get_action_strength("right")
		var swing_influence_factor = 0.1 + 0.5 * (1.0 - dot_product) * 0.5  # Adjust as needed
		
		if swing_influence > 0:
			target_swing_direction = -perpendicular
		else:
			target_swing_direction = perpendicular
			

		velocity += perpendicular * (PLAYER_HOOK_SPEED * swing_influence * swing_influence_factor)
		
		var air_resistance = 0.89  # Adjust as needed
		velocity *= air_resistance
		
		velocity.x += swing_influence * swing_influence_factor
		global_position += global_position.direction_to(hook.global_position) * swing_pull * delta
		
	if hook_to_player_length <= HOOK_MAX_LENGTH and hook_state == HookStates.HOOKED:
		if Input.is_action_pressed("retract"):
			global_position += global_position.direction_to(hook.global_position) * HOOK_SPEED * delta
		elif Input.is_action_pressed("extract"):
			global_position -= global_position.direction_to(hook.global_position) * HOOK_SPEED * delta


			
	

func extend_hook_logic(delta):
	
	var new_hook_position = hook.global_position + hook_direction * HOOK_SPEED * delta
	var distance_to_player = new_hook_position.distance_to(global_position)
	hook.global_position += hook_direction * HOOK_SPEED * delta

	if distance_to_player >= HOOK_MAX_LENGTH:
		hook_state = HookStates.RETRACT_TO_PLAYER
		player_state = PlayerStates.DEFAULT
		
	elif $Hook.body_entered:
		HOOK_LENGTH = distance_to_player
		player_state = PlayerStates.HOOKED
		hook.global_position = new_hook_position
		
	else:
		hook.global_position += hook_direction * HOOK_SPEED * delta


func retract_hook_logic(delta):
		hook.global_position += hook.global_position.direction_to(global_position) * HOOK_SPEED * delta
		if hook.global_position.distance_to(global_position) <= HOOK_SPEED * delta:
			player_state = PlayerStates.DEFAULT
			hook_state = HookStates.NONE
			hide_hook()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and hook_state == HookStates.NONE and not paused:
		hook.global_position = global_position
		var hook_target = get_local_mouse_position().normalized() * HOOK_MAX_LENGTH
		hook_state = HookStates.EXTEND
		hook_direction = get_local_mouse_position().normalized()
		hook.show()
		line.show()
		hook_shape.disabled = false



func _on_hook_body_entered(_body: Node2D) -> void:
	var hook_distance = hook.position.distance_to(global_position)
	if hook_distance <= HOOK_MAX_LENGTH:
		player_state = PlayerStates.HOOKED
		velocity = global_position.direction_to(hook.global_position) * PLAYER_HOOK_SPEED
		hook_state = HookStates.HOOKED
		hook_shape.set_disabled.call_deferred(true)
		

func hide_hook() -> void:
	hook.hide()
	line.hide()
	
	hook_shape.set_disabled.call_deferred(true)


func _on_death_colider_body_entered(body):
	position.x = 320
	position.y = 150
	hide_hook()
	$Camera2D.reset_smoothing()
	



func _on_tree_entered():
	
	if get_tree() != null and get_tree().current_scene != null:
		var current_scene_name = get_tree().current_scene.name
		print("Current Scene: ", current_scene_name)
		if current_scene_name != "MainMenu":
			paused = true
		if current_scene_name == "first_level":
			$Camera2D/hud.show()
			$Camera2D.make_current()
			position.y = 150
			position.x = 320
			LEVEL = 1
			$Camera2D.reset_smoothing()
			show()
			print("Character Visible and moved to", position)
		elif current_scene_name == "MainMenu":
			$Camera2D/hud.hide()
			hide()
			print("Character Hidden")
		else:
			$Camera2D/hud.hide()
			show()
			print("Character Visible")
	else:
		print("Invalid SceneTree or current scene.")


func _on_step_sfx_timeout():
	if (velocity.x < 0  or velocity.x > 0) and velocity.y==0 and get_tree().current_scene.name != 'MainMenu':
		if $AudioStreamPlayer2D.playing == false:
			$AudioStreamPlayer2D.play()


