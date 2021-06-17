extends Furniture

func interact(body : Player) -> void:
  if body.tools.has("Frozen bread with butter knife") and !item_collected:
    Util.swap_message(collected)
    body.tools.erase("Frozen bread with butter knife")
    body.collect_tool("Burnt bread")
    body.collect_tool("Butter knife")
    item_collected = true
    $Sprite.play("break")
    $Audio.play()
  else:
    Util.swap_message("I have nothing to microwave")
    Util.shake()
