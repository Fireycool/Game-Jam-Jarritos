extends Control

var alive: bool = true
var heart_list : Array[TextureRect]
var health = 5
var maxHealth = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var heart_parent = $HeartsContainer
	for child in heart_parent.get_children():
		heart_list.append(child)
	#print(heart_list)

func take_damage():
	if health>0:
		health -= 1
		update_heart_display()
		
func update_heart_display():
	for i in range(heart_list.size()):
		heart_list[i].visible = i < health
		
	if health <= 0:
		alive = false
		death()
		
func death():
	print("The player has died")
	
func heal():
	if health < maxHealth:
		health += 1
		update_heart_display()
