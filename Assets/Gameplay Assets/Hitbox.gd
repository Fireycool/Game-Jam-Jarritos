class_name MyHitbox
extends Area2D

@export var damage := 1

func _init() -> void:
	collision_layer = 64
	collision_mask = 32
