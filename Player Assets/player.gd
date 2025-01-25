extends CharacterBody2D


const SPEED = 350.0
const ACCELERATION = 1200.0
const FRICTION = 1400.0

const GRAVITY = 2000.0
const FALL_GRAVITY = 3000.0
const FAST_FALL_GRAVITY = 5000.0
const WALL_GRAVITY = 25.0

const JUMP_VELOCITY = -700.0
const WALL_JUMP_VELOCITY = -700.0
const WALL_JUMP_PUSHBACK = 300.0

const INPUT_BUTTER_PATIENCE = 0.1
const COYOTE_TIME = 0.08

const SHOOT_KNOCKBACK = 300.0
const SHOOT_JUMP = 800.0

var input_buffer : Timer
var coyote_timer : Timer
var coyote_jump_available : bool = true


func _ready():
	# Setup Input Buffer Timer
	input_buffer = Timer.new()
	input_buffer.wait_time = INPUT_BUTTER_PATIENCE
	input_buffer.one_shot = true
	add_child(input_buffer)
	
	# Setup coyote Timer
	coyote_timer = Timer.new()
	coyote_timer.wait_time = COYOTE_TIME
	coyote_timer.one_shot = true
	add_child(coyote_timer)
	coyote_timer.timeout.connect(coyote_timeout)

func _physics_process(delta):
	var horizontal_input = Input.get_axis("left","right")

func coyote_timeout():
	coyote_jump_available = false
