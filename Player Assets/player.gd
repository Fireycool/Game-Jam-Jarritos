extends CharacterBody2D


const SPEED = 350.0
const ACCELERATION = 1200.0
const FRICTION = 1400.0

const GRAVITY = 1500.0
const FALL_GRAVITY = 3000.0
const FAST_FALL_GRAVITY = 5000.0
const WALL_GRAVITY = 25.0

const JUMP_VELOCITY = -700.0
const WALL_JUMP_VELOCITY = -700.0
const WALL_JUMP_PUSHBACK = 300.0

const INPUT_BUTTER_PATIENCE = 0.1
const COYOTE_TIME = 0.08

const SHOOT_RECOIL = 300.0
const SHOOT_JUMP = 800.0

var input_buffer : Timer
var coyote_timer : Timer
var coyote_jump_available : bool = true


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
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4
	
	
	if is_on_floor():
		coyote_jump_available = true
		coyote_timer.stop()
	else:
		if coyote_jump_available:
			if coyote_timer.is_stopped():
				coyote_timer.start()
		velocity.y += get_grav(horizontal_input) * delta
	
	# Movimiento Horizontal y Friccion
	var floor_damping : float = 1.0 if is_on_floor() else 0.2
	if horizontal_input:
		velocity.x = move_toward(velocity.x, horizontal_input * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, (FRICTION * delta) * floor_damping)
	
	
	
	
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
