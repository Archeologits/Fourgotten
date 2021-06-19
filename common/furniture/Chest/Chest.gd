extends Furniture

func interact(body : Player) -> void:
  if body.tools.has("Quill") and !item_collected:
    Util.swap_message(body.number, collected)
    body.collect_tool(tool_name)
    item_collected = true
    $Sprite.play("open")
    $Audio.play()
  else:
    Util.swap_message(body.number, "...")
    Util.shake()
