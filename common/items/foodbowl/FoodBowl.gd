extends Item

func interact(body : Player) -> void:
  if body.tools.has("Weird food"):
    Util.swap_message(collected)
    body.tools.erase("Weird food")
    body.collect_tool("Green key")
    item_collected = true
  else:
    Util.swap_message("...")
    Util.shake()
