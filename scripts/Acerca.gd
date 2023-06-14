extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$anims.play("MenuTransitions/transitionIn")
	get_viewport().connect("size_changed", _on_screen_resized)
	_on_screen_resized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_button_up():
	$anims.play("MenuTransitions/transitionOut")
	await get_tree().create_timer(1).timeout
	
	print_debug("[MainMenu] Cambiando escena")
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_button_pressed():
	_on_button_button_up()

# Ajuste dinamico de ventana.
func _on_screen_resized():
	var windowsize: Vector2 = get_viewport_rect().size
	$PanelContainer.position = Vector2(
		windowsize.x*.5 - 400,
		0,
	)
	pass
