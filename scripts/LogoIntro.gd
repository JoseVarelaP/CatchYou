extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("FadeOutIntro")
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play_backwards("FadeOutIntro")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
