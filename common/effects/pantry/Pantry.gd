extends ColorRect

func _on_door_opened():
  $Animation.play("reveal")
  yield($Animation, "animation_finished")
  queue_free()
