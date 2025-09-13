extends Sprite2D

func _ready() -> void:
	move_right_and_back()

func move_right_and_back():
	# test tween to help show caling better.
	var tween = create_tween()
	var original_position = position
	
	tween.set_loops()	
	
	# Move logo right with smooth easing
	tween.tween_property(self, "position", position + Vector2(400, 0), 1.0)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	
	# Move logo back with different easing
	tween.tween_property(self, "position", original_position, 1.0)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
