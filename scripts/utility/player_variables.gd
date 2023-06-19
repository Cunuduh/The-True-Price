extends Node
signal work_value_changed(value: int)
signal dopamine_value_changed(value: int)
var work := 0:
	set(value):
		work = clampi(value, 0, 100)
		emit_signal("work_value_changed", work)
var dopamine := 75:
	set(value):
		dopamine = clampi(value, 0, 100)
		emit_signal("dopamine_value_changed", dopamine)
var average_dopamine: PackedInt32Array
var vape_hits := 0
var won := false
var score := 0
var vapes_rejected := 0

func get_score() -> int:
	var average := 0
	for n in average_dopamine:
		average += n
	average /= average_dopamine.size() if average_dopamine.size() > 0 else 1
	score = work + average
	score -= vape_hits * 10
	return score
