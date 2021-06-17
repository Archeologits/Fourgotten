extends Item

func interact(body : Player) -> void:
  if body.tools.has("Quill") and !item_collected:
    Util.swap_message(collected)
    body.tools.erase("Quill")
    body.collect_tool("Wine")
    item_collected = true
    $Sprite.visible = false
#    $Audio.play()
  else:
    Util.swap_message("...")
    Util.shake()
