extends ColorRect

func _on_door_opened(_player : Player) -> void:
  $Animation.play("reveal")
  yield($Animation, "animation_finished")
  queue_free()
