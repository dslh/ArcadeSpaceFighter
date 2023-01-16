extends Control

var final_score: int = false

var new_high_score: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LineEdit.grab_focus()
	final_score = HighScoreManager.current_score
	new_high_score = HighScoreManager.is_new_high_score(final_score)


func _on_LineEdit_text_entered(new_text: String) -> void:
	$LineEdit.set_editable(false)
	
	if new_high_score:
		HighScoreManager.add_high_score(final_score, new_text)
	
	SceneChanger.change_scene("res://menu/main_menu.tscn",0)

