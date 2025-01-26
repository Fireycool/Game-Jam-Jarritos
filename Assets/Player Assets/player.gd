extends CharacterBody2D


@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var right_sprite_2d = $Right_Shot
@onready var left_sprite_2d = $Left_Shot
@onready var down_sprite_2d = $Down_Shot

@export var SPEED = 350.0
@export var ACCELERATION = 1200.0
@export var FRICTION = 1400.0

@export var GRAVITY = 1500.0
@export var FALL_GRAVITY = 3000.0
@export var FAST_FALL_GRAVITY = 5000.0
@export var WALL_GRAVITY = 25.0

@export var JUMP_VELOCITY = -700.0
@export var WALL_JUMP_VELOCITY = -700.0
@export var WALL_JUMP_PUSHBACK = 300.0

@export var INPUT_BUTTER_PATIENCE = 0.1
@export var COYOTE_TIME = 0.08

@export var SHOOT_RECOIL = 700.0
@export var SHOOT_BOOST = -100.0
@export var SHOOT_JUMP = -800.0

var input_buffer : Timer
var coyote_timer : Timer
var coyote_jump_available : bool = true
var direction = 1
var shoot_right = false
var shoot_left = false
var shoot_down = false
var speen = false

var heart_list : Array[TextureRect]
var health = 5 
var maxHealth = 5

func _ready():
	# Setup del Input Buffer Timer
	input_buffer = Timer.new()
	input_buffer.wait_time = INPUT_BUTTER_PATIENCE
	input_buffer.one_shot = true
	add_child(input_buffer)
	
	# Setup del Coyote Timer
	coyote_timer = Timer.new()
	coyote_timer.wait_time = COYOTE_TIME
	coyote_timer.one_shot = true
	add_child(coyote_timer)
	coyote_timer.timeout.connect(coyote_timeout)

func _physics_process(delta):
	var horizontal_input = Input.get_axis("left","right")
	var jump_attempted = Input.is_action_just_pressed("jump")
	var side_shot_attempted = Input.is_action_just_pressed("shoot side")
	var down_shot_attempted = Input.is_action_just_pressed("shoot down")
	
	
	# Manejo de Salto y agregar Gravedad
	if jump_attempted or input_buffer.time_left > 0:
		if coyote_jump_available:
			velocity.y = JUMP_VELOCITY
			coyote_jump_available = false
		elif is_on_wall() and horizontal_input != 0:
			velocity.y = WALL_JUMP_VELOCITY
			velocity.x = WALL_JUMP_PUSHBACK * -sign(horizontal_input)
		elif jump_attempted:
			input_buffer.start()
		speen = false
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4
	
	if velocity.y < 0:
		animated_sprite_2d.play("JUMP")
	elif velocity.y > 0 and !is_on_floor():
		animated_sprite_2d.play("FALL")
	
	if is_on_floor():
		coyote_jump_available = true
		coyote_timer.stop()
		speen = false
	else:
		if coyote_jump_available:
			if coyote_timer.is_stopped():
				coyote_timer.start()
		velocity.y += get_grav(horizontal_input) * delta
	
	# Movimiento Horizontal y Friccion
	var floor_damping : float = 1.0 if is_on_floor() else 0.2
	if horizontal_input:
		velocity.x = move_toward(velocity.x, horizontal_input * SPEED, ACCELERATION * delta)
		if is_on_floor():
			animated_sprite_2d.play("RUN")
		direction = horizontal_input
	else:
		velocity.x = move_toward(velocity.x, 0, (FRICTION * delta) * floor_damping)
		if is_on_floor():
			animated_sprite_2d.play("default")
	
	#DISPARO
	if side_shot_attempted:
		speen = false
		#ANIMACION DE DISPARO
		if direction > 0 and !shoot_right:
			velocity.x = SHOOT_RECOIL * -sign(direction)
			if velocity.y != 0:
				if velocity.y < 0:
					velocity.y = velocity.y + SHOOT_BOOST
				else:
					velocity.y = SHOOT_BOOST
			right_sprite_2d.play("SHOT")
			shoot_right = true
			$Right_Shot/Right_Hitbox/CollisionShape2D.disabled = false
		elif direction < 0 and !shoot_left:
			velocity.x = SHOOT_RECOIL * -sign(direction)
			if velocity.y != 0:
				if velocity.y < 0:
					velocity.y = velocity.y + SHOOT_BOOST
				else:
					velocity.y = SHOOT_BOOST
			left_sprite_2d.play("SHOT")
			shoot_left = true
			$Left_Shot/Left_Hitbox/CollisionShape2D.disabled = false
	
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true

	
	if down_shot_attempted and !shoot_down:
		velocity.y = SHOOT_JUMP
		speen = true
		down_sprite_2d.play("SHOT")
		shoot_down = true
		$Down_Shot/Lower_Hitbox/CollisionShape2D.disabled = false
	
	# Aplicar Velocidad
	move_and_slide()

# Manejo de Cambios de Gravedad
func get_grav(input_dir : float = 0) -> float:
	if Input.is_action_pressed("fast fall"):
		return FAST_FALL_GRAVITY
	if is_on_wall_only() and velocity.y > 0 and input_dir != 0:
		return WALL_GRAVITY
	return GRAVITY if velocity.y < 0 else FALL_GRAVITY

# Reset coyote jump
func coyote_timeout() -> void:
	coyote_jump_available = false

# Reset Right Shot
func _on_right_shot_animation_finished():
	if right_sprite_2d.animation == "SHOT":
		shoot_right = false
		$Right_Shot/Right_Hitbox/CollisionShape2D.disabled = true
		right_sprite_2d.play("default")

func _on_left_shot_animation_finished():
	if left_sprite_2d.animation == "SHOT":
		shoot_left = false
		$Left_Shot/Left_Hitbox/CollisionShape2D.disabled = true
		left_sprite_2d.play("default")

func _on_down_shot_animation_finished():
	if down_sprite_2d.animation == "SHOT":
		shoot_down = false
		$Down_Shot/Lower_Hitbox/CollisionShape2D.disabled = true
		down_sprite_2d.play("default")
