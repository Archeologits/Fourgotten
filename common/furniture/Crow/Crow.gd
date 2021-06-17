extends Furniture
class_name Crow

var quill_collected : bool  = false

func interact(body : Player) -> void:
  if !quill_collected:
    Util.swap_message("Got a quill!")
    body.collect_tool("Quill")
    quill_collected = true
  elif body.tools.has("Butter knife") and !item_collected:
    Util.swap_message("Got a stuffed crow!")
    body.collect_tool("Stuffed crow")
    item_collected = true
    # If audio added - simply uncomment the following
#    $Audio.play()
  else:
    Util.shake()
    Util.swap_message("...")

func _on_player_exited(body : Node2D) -> void:
  if interactible and body == last_player:
    Util.pop_message()
    body.interactible = null
    if item_collected:
      queue_free()
