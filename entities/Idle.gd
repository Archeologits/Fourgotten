extends State

func enter() -> void:
  """ Play sound and animations """
  parent.audio.stop()
  parent.body.hide()
  parent.static_image.show()

  if parent.facing.x > 0:
    parent.static_image.texture = parent.body.frames.get_frame("right", 0)
  elif parent.facing.x < 0:
    parent.static_image.texture = parent.body.frames.get_frame("left", 1)      
  elif parent.facing.y < 0:
    parent.static_image.texture = parent.body.frames.get_frame("up", 0)
  elif parent.facing.y > 0:
    parent.static_image.texture = parent.body.frames.get_frame("down", 0)

func process(_delta : float) -> void:
  """ State logic """
  if parent.direction != Vector2.ZERO:
    exit("Walk")
