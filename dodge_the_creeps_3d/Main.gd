extends Node

export(PackedScene) var mob_scene
export(PackedScene) var bullet_scene


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
	var bullet = bullet_scene.instance()
	var player_position = $Player.transform.origin
	bullet.initialize(player_position)
	add_child(bullet)
