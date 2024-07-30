extends Node2D

static var SPEED = 50
static var V_RIGHT = Vector2(1, 0)
static var V_LEFT = Vector2(-1, 0)
static var V_UP = Vector2(0, -1)
static var V_DOWN = Vector2(0, 1)
var human
var orc
var human_in_attacking_range = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("HumanBody2D/AnimatedSprite2D").play("idle")
	get_node("OrcBody2D/AnimatedSprite2D").play("idle")
	human = get_node("HumanBody2D")
	orc = get_node("OrcBody2D")
	
func get_input():
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	return input_dir * SPEED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		get_node("HumanBody2D/AnimatedSprite2D").play("attack")
	else:
		get_node("HumanBody2D/AnimatedSprite2D").play("idle")
	
	if is_human_in_attacking_range() && is_human_attacking(): 
		print("Orc is damaged!")
	
	get_input()
	human.move_and_collide(get_input() * delta)

func is_human_in_attacking_range():
	return human_in_attacking_range

func is_human_attacking():
	var animated_sprite = get_node("HumanBody2D/AnimatedSprite2D")
	return animated_sprite.is_playing() && \
		animated_sprite.animation == "attack" && \
		(animated_sprite.frame == 1 || animated_sprite.frame == 2)

func _on_orc_damage_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	human_in_attacking_range = true

func _on_orc_damage_area_2d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	human_in_attacking_range = false
