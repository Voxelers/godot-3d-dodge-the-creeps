extends Label

var hits = 0


func _on_Mob_hit_by_bullet():
	hits += 1
	text = "Hits: %s" % hits
