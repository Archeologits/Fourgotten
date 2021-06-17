extends GarbageChute
class_name BedroomGarbageChute

func _ready() -> void:
  other_chute = get_node("../../GreenRoom/KitchenGarbageChute")
  other_chute.connect("chute_opened", self, "_on_chute_opened")
  connect("chute_opened", self, "_on_chute_opened")

func interact(body : Player) -> void:
  if !chute_opened and body.tools.has("Red key"):
    _open_chute()

    # Quality of life improvements - check contents of garbage chute for player
#    if body.tools.has("Wine"):
#      $Timer.start()
#      yield($Timer, "timeout")
#      Util.swap_message("Put wine in garbage chute? (E)")
##      if body.tools.has("Rotten meat"):
##        Util.swap_message("Put rotten meat in garbage chute? (E)")        
#    elif body.tools.has("Rotten meat"):
#      $Timer.start()
#      yield($Timer, "timeout")
#      Util.swap_message("Put rotten meat in garbage chute? (E)")

  elif chute_opened:

    if body.tools.has("Wine"):
      if other_chute.tool_name == "":
        other_chute.tool_name = "Wine"
      else:
        other_chute.tool_name_2 = "Wine"       
      body.tools.erase("Wine")
      Util.swap_message("Wine is in garbage chute")

    elif body.tools.has("Rotten meat"):

      if other_chute.tool_name == "":
        other_chute.tool_name = "Rotten meat"
      else:
        other_chute.tool_name_2 = "Rotten meat"
      body.tools.erase("Rotten meat")
      Util.swap_message("Rotten meat is in garbage chute")
