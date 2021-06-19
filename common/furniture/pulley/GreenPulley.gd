extends Furniture

# Member variables
onready var other_pulley := get_node("../../BlueRoom/BluePulley")

func interact(body : Player) -> void:
  if $RecipeBook.visible:
    Util.swap_message(body.number, collected)
    body.collect_tool(tool_name)
    item_collected = true
    $RecipeBook.queue_free()
  else:
    Util.swap_message(body.number, "There is nothing here")
    Util.shake()

func load_recipe_book() -> void:
  $RecipeBook.visible = true
