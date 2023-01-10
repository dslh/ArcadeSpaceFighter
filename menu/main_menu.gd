extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yield($AnimationPlayer, "animation_finished")
	$VBoxContainer/Play/Button.grab_focus()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("fire_laser"):
		SceneChanger.change_scene("res://game/game.tscn")
		MusicManager._change_track_to("Game", 3.0)


func _on_Play_pressed() -> void:
	_disable_buttons()
	SceneChanger.change_scene("res://game/game.tscn")
	MusicManager._change_track_to("Game", 3.0)


func _on_Quit_pressed() -> void:
	_disable_buttons()
	get_tree().quit()


func _disable_buttons() -> void:
	$VBoxContainer/Play/Button.set_focus_mode(Control.FOCUS_NONE)
	$VBoxContainer/Quit/Button.set_focus_mode(Control.FOCUS_NONE)
