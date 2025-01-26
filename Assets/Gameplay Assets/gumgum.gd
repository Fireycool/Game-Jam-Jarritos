extends Node2D

@export var SPEED = 500
var player_pos
var target_pos

@onready var player = $"../Player"
@onready var health = $GumHealth


func _ready() -> void:
	health.value = 3

func _physics_process(delta: float) -> void:
	player_pos = player.position
	target_pos = (player_pos - position).normalized()
	
	if position.distance_to(player_pos) > 3:
		position += target_pos * SPEED * delta
	
	if health.value == 0:
		self.queue_free()

func take_damage(amount: int) -> void:
	health.value = health.value - amount
