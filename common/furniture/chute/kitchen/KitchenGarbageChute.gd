extends GarbageChute
class_name KitchenGarbageChute

func _ready() -> void:
  other_chute = get_node("../../RedRoom/BedroomGarbageChute")
  other_chute.connect("chute_opened", self, "_on_chute_opened")
  connect("chute_opened", self, "_on_chute_opened")

func interact(body : Player) -> void:
  if !chute_opened and body.tools.has("Butter knife"):
    _open_chute()
    
    # Quality of life improvements - check if they have wine or rotten meat
    if [tool_name, tool_name_2].has("Wine"):
      $Timer.start()
      yield($Timer, "timeout")
      Util.swap_message("Pick up wine? (E)")
    elif [tool_name, tool_name_2].has("Rotten meat"):
      $Timer.start()
      yield($Timer, "timeout")
      Util.swap_message("Pick up rotten meat? (E)")

  elif chute_opened and !item_collected and tool_name != "":
    Util.swap_message("Found a " + tool_name.to_lower() + "!!")
    body.collect_tool(tool_name)
    tool_name = ""
  elif chute_opened and !item_collected and tool_name_2 != "":
    Util.swap_message("Found a " + tool_name_2.to_lower() + "!!")
    body.collect_tool(tool_name_2)
    tool_name_2 = ""
#    item_collected = true
