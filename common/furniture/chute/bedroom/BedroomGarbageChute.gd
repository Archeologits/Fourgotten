extends GarbageChute

func _ready() -> void:
  other_chute = get_node("../../GreenRoom/KitchenGarbageChute")
  other_chute.connect("chute_opened", self, "_on_chute_opened")
  connect("chute_opened", self, "_on_chute_opened")

func interact(body : Player) -> void:
  if !chute_opened and body.tools.has("Red key"):
    _open_chute(body.number)

    # Quality of life improvements - check if they have wine or rotten meat
    if body.tools.has("Wine") and body.tools.has("Rotten meat"):
      $Timer.start()
      yield($Timer, "timeout")
      if $Interact.overlaps_body(body):
        Util.swap_message(body.number, "Drop wine & rotten meat in garbage chute? (E)")
    elif body.tools.has("Wine"):
      $Timer.start()
      yield($Timer, "timeout")
      if $Interact.overlaps_body(body):
        Util.swap_message(body.number, "Drop wine in garbage chute? (E)")
    elif body.tools.has("Rotten meat"):
      $Timer.start()
      yield($Timer, "timeout")
      if $Interact.overlaps_body(body):
        Util.swap_message(body.number, "Drop rotten meat in garbage chute? (E)")

  elif chute_opened:

    if body.tools.has("Wine") and body.tools.has("Rotten meat"):
      other_chute.tools.push_back("Wine")
      other_chute.tools.push_back("Rotten meat")
      body.erase_tool("Wine")
      body.erase_tool("Rotten meat")
      Util.swap_message(body.number, "Wine and rotten meat are in garbage chute")
      $Timer.start()
      yield($Timer, "timeout")
      $Interact.queue_free()
    elif body.tools.has("Wine"):
      other_chute.tools.push_back("Wine") 
      body.erase_tool("Wine")
      Util.swap_message(body.number, "Wine is in garbage chute")
    elif body.tools.has("Rotten meat"):
      other_chute.tools.push_back("Rotten meat")
      body.erase_tool("Rotten meat")
      Util.swap_message(body.number, "Rotten meat is in garbage chute")
  
  else:
    Util.swap_message(body.number, "...")
    Util.shake()
