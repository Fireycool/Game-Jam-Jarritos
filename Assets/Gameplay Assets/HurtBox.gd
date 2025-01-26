class_name MyHurtBox
extends Area2D

@export var damage := 1

func _init() -> void:
	collision_layer = 8
	collision_mask = 16

func _ready() -> void:
	connect("area_entered",self._on_area_entered)


func _on_area_entered(hitbox: MyHitbox) -> void:
	if hitbox == null:
		return
	
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
