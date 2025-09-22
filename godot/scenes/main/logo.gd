extends Sprite2D

func _ready() -> void:
	pass
#	move_right_and_back()
	pulse_fade()

func pulse_fade(duration: float = 10.5):
	# more tween fun :)
	var tween = create_tween()
	var original_alpha = modulate.a
	var half_duration = duration / 2
	tween.set_loops()
	# Fade out
	tween.tween_property(self, "modulate:a", 0.1, half_duration)
	# Fade back to original
	tween.tween_property(self, "modulate:a", original_alpha, half_duration)


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
