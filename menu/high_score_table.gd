extends VBoxContainer

var count: int = 0

onready var top_score_label = $MarginContainer2/TopScore

func _ready() -> void:
	var top_score = HighScoreManager.get_top_score()
	top_score_label.display_specific_score(1, top_score[1], top_score[0])


func update_display() -> void:
	var labels = $MarginContainer3/Scores.get_children()
	for i in $MarginContainer3/Scores.get_child_count():
		labels[i] as HighScoreLabel
		labels[i].display_specific_score(i+2, HighScoreManager.high_scores[i+1][1], HighScoreManager.high_scores[i+1][0], i)



func _on_Timer_timeout() -> void:
	update_display()
