extends Line2D




func drag(_drag_from, drag_to):
	points[0] = _drag_from
	points[1] = _drag_from.lerp(drag_to, 0.5)
	points[2] = drag_to;