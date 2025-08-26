extends Control

func set_score(score : int):
	$ScoreLabel.text = 'Score: ' + str(score)


func show_retry():
	$Retry.show()


func hide_retry():
	$Retry.hide()
