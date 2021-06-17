extends GarbageChute

func _ready() -> void:
  other_chute = get_node("../../GreenRoom/KitchenGarbageChute")
  other_chute.connect("chute_opened", self, "_on_chute_opened")
  connect("chute_opened", self, "_on_chute_opened")

func interact(body : Player) -> void:
  if !chute_opened and body.tools.has("Red key"):
    _open_chute()

    # Quality of life improvements - check if they have wine or rotten meat
    if body.tools.has("Wine") and body.tools.has("Rotten meat"):
      $Timer.start()
      yield($Timer, "timeout")
      Util.swap_message("Drop wine and rotten meat in garbage chute? (E)")
    if body.tools.has("Wine"):
      $Timer.start()
      yield($Timer, "timeout")
      Util.swap_message("Drop wine in garbage chute? (E)")
    elif body.tools.has("Rotten meat"):
      $Timer.start()
      yield($Timer, "timeout")
      Util.swap_message("Drop rotten meat in garbage chute? (E)")

  elif chute_opened:

    if body.tools.has("Wine") and body.tools.has("Rotten meat"):
      other_chute.tools.push_back("Wine")
      other_chute.tools.push_back("Rotten meat")
      body.tools.erase("Wine")
      body.tools.erase("Rotten meat")      
      Util.swap_message("Wine and rotten meat are in garbage chute")
    if body.tools.has("Wine"):
      other_chute.tools.push_back("Wine") 
      body.tools.erase("Wine")
      Util.swap_message("Wine is in garbage chute")
    elif body.tools.has("Rotten meat"):
      other_chute.tools.push_back("Rotten meat")
      body.tools.erase("Rotten meat")
      Util.swap_message("Rotten meat is in garbage chute")
