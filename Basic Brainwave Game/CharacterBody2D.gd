extends CharacterBody2D

@export_range(0,750) var speed = 3600

var btr=0

static var n = 1

func _process(delta):
	
	var brain_signal = get_node("/root/Node2D/CharacterBody2D/brain_port").btr
	var attention = brain_signal*3
	#var alpha_signal = get_node("/root/Node2D/CharacterBody2D/brain_port").a
	#var attention = alpha_signal * 8
	print("Attention: %s" % attention)

	#velocity = Vector2.RIGHT * speed * attention/100
	velocity = Vector2.RIGHT * speed * attention/100
	
	move_and_slide()
	
