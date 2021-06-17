extends Furniture

func interact(body : Player) -> void:
  if body.tools.has("Quill") and !item_collected:
    Util.swap_message(collected)
    body.collect_tool("Blue key")
    item_collected = true
    $Sprite.play("open")
#    $Audio.play()
  else:
    Util.shake()
