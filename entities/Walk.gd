extends State

func enter() -> void:
  """ Play sound and animations """
  parent.audio.play()
  parent.body.show()
  parent.static_image.hide()

func process(_delta : float) -> void:
  """ State logic """
  if parent.direction.x > 0:
    parent.body.play("right")
  elif parent.direction.x < 0:
    parent.body.play("left")
  elif parent.direction.y < 0:
    parent.body.play("up")
  elif parent.direction.y > 0:
    parent.body.play("down")
  else:
    exit("Idle")
