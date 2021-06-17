extends Furniture

# Member variables
onready var other_pulley := get_node("../../GreenRoom/GreenPulley")
onready var red_card_passage := get_node("../RedCardPassage")
signal pulley_used

func interact(body : Player) -> void:
  if body.tools.has("Recipe") and !item_collected:
    Util.swap_message(collected)
    body.tools.erase("Recipe")
    body.collect_tool("Red key")
    other_pulley.load_recipe_book()

    # Activate the red card passage
    red_card_passage.activate()
    item_collected = true
    $Audio.play()
  else:
    Util.swap_message("I have nothing to send")
    Util.shake()
