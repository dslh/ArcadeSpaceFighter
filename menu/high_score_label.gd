class_name HighScoreLabel

extends HBoxContainer


func display_specific_score(n: int = 0, id: String = "", score: int = 0, delay_factor: int = 0) -> void:
	$Number.text = str(n)+ "."
	$ID.text = id 
	$Score.text = str(score)
	#tween the appearence of the text, from left to right
	var delay: float = delay_factor * 0.4
	$Tween.interpolate_property($Number, "percent_visible", 0.0, 1.0, 0.2, delay)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$Tween.interpolate_property($ID, "percent_visible", 0.0, 1.0, 0.2, 0.0)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$Tween.interpolate_property($Score, "percent_visible", 0.0, 1.0, 0.2, 0.0)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	

func clear_all_text() -> void:
	for child in get_children():
		if child is Label: 
			child.set_text("")
			child.percent_visible = 0.0
