extends Node

@export var mob_scene: PackedScene
@export var player_scene: PackedScene

var score : int = 0
var is_player_alive : bool = false

func new_game():
	var player = player_scene.instantiate()
	player.position = $PlayerStartPosition.position
	add_child(player)
	player.hit.connect(_on_player_hit)

	score = 0
	is_player_alive = true
	$HUD.set_score(score)
	$HUD.hide_retry()
	$MobTimer.start()


func game_over():
	$MobTimer.stop()
	$HUD.show_retry()
	is_player_alive = false


func _unhandled_input(event):
	if event.is_action_pressed("retry") and not is_player_alive:
		new_game()


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()

	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)

	add_child(mob)

	mob.squashed.connect(_on_mob_squashed)


func _on_mob_squashed():
	score += 1
	$HUD.set_score(score)


func _on_player_hit():
	game_over()
