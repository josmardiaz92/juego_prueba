extends Node2D

func go_player(track)->void:
	match track:
		"crunch":
			$Crunch.play()
		"enter":
			$Enter.play()
		"loser":
			$Loser.play()
			
