extends GarbageChute

func _ready() -> void:
  other_chute = get_node("../../RedRoom/BedroomGarbageChute")
  other_chute.connect("chute_opened", self, "_on_chute_opened")
  connect("chute_opened", self, "_on_chute_opened")

func interact(body : Player) -> void:
  if !chute_opened and body.tools.has("Butter knife"):
    _open_chute(body.number)

    # Quality of life improvements - check if they have wine or rotten meat
    if tools.has("Wine") and tools.has("Rotten meat"):
      $Timer.start()
      yield($Timer, "timeout")
      Util.swap_message(body.number, "Pick up wine and rotten meat? (E)")
    elif tools.has("Wine"):
      $Timer.start()
      yield($Timer, "timeout")
      Util.swap_message(body.number, "Pick up wine? (E)")
    elif tools.has("Rotten meat"):
      $Timer.start()
      yield($Timer, "timeout")
      Util.swap_message(body.number, "Pick up rotten meat? (E)")

  elif chute_opened and !item_collected and !tools.empty():

    if tools.has("Wine") and tools.has("Rotten meat"):
      Util.swap_message(body.number, "Found wine and rotten meat!")
      body.collect_tool("Wine")
      body.collect_tool("Rotten meat")
      tools.clear()
    elif tools.has("Wine"):
      Util.swap_message(body.number, "Found wine!")
      body.collect_tool("Wine")
      tools.clear()
    elif tools.has("Rotten meat"):
      Util.swap_message(body.number, "Found rotten meat!")
      body.collect_tool("Rotten meat")
      tools.clear()

  else:
    Util.swap_message(body.number, "...")
    Util.shake()
