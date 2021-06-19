extends Item

func interact(body : Player) -> void:
  if body.tools.has("Quill") and !item_collected:
    Util.swap_message(body.number, collected)
    body.erase_tool("Quill")
    body.collect_tool(tool_name)
    item_collected = true
    $Sprite.visible = false
#    $Audio.play()
  else:
    Util.swap_message(body.number, "...")
    Util.shake()
