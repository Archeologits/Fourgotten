extends Door

var confirmed : bool = false

func interact(body : Player) -> void:
  if !confirmed:
    Util.swap_message(body.number, "Are you sure you want to leave?")
    pass
  else:
    # Play opening animation and remove collisions/interaction shapes
    Util.swap_message(body.number, opened)
    door_opened = true
    $Collision.queue_free()
    $Interact.queue_free()
    $Audio.play()
    play("open")
    emit_signal("opened")

func _on_player_exited(body : Node2D) -> void:
  # The messaging system has been updated so no need to check if last_player
  if interactible and body.is_in_group("Players"):
    Util.pop_message(body.number)
    body.interactible = null
    if door_opened:
      interactible = false
