extends Item

func interact(body : Player) -> void:
  if body.tools.has("Weird food"):
    Util.swap_message(body.number, collected)
    body.erase_tool("Weird food")
    body.collect_tool(tool_name)
    item_collected = true
    $Audio.play()
  else:
    Util.swap_message(body.number, "...")
    Util.shake()
