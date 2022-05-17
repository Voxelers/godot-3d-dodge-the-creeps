extends Node

export(PackedScene) var mob_scene
export(PackedScene) var bullet_scene

# Bullets conifg
export var max_bullets = 5
var bullets_group = 'bullets'
var last_time_fired = 0
var min_fire_delay_ms = 100

func _ready():
	randomize()
	$UserInterface/Retry.hide()


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()


func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instance()

	# Choose a random location on the SpawnPath.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.unit_offset = randf()

	# Communicate the spawn location and the player's location to the mob.
	var player_position = $Player.transform.origin
	mob.initialize(mob_spawn_location.translation, player_position)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	# We connect the mob to the score label to update the score upon squashing a mob.
	mob.connect("squashed", $UserInterface/ScoreLabel, "_on_Mob_squashed")


func _on_Player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()


func _on_Player_fire():
	var number_of_bullets = len(get_tree().get_nodes_in_group(bullets_group))
	var fire_delay_ms = OS.get_ticks_msec() - last_time_fired
	if number_of_bullets < max_bullets and  fire_delay_ms > min_fire_delay_ms:
		last_time_fired = OS.get_ticks_msec()
		var bullet = bullet_scene.instance()
		var player_position = $Player.transform.origin
		var pivot = get_tree().get_root().get_node("Main/Player/Pivot")
		bullet.initialize(player_position, pivot.rotation)
		add_child(bullet)
