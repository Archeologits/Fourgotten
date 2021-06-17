extends Furniture
class_name GreenPulley

# Member variables
onready var other_pulley := get_node("../../BlueRoom/BluePulley")

func interact(body : Player) -> void:
  if $RecipeBook.visible:
    Util.swap_message(collected)
    body.collect_tool("Recipe")
    item_collected = true
    $RecipeBook.queue_free()
#    $Audio.play()
  else:
    Util.shake()
    Util.swap_message("There is nothing here")

func load_recipe_book() -> void:
  $RecipeBook.visible = true
