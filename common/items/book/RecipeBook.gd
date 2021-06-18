extends Item

# Member variables
onready var destination : Position2D = get_node("../RecipeBookDestination")
var pushed_down : bool = false

func interact(body : Player) -> void:
  if !pushed_down:
    # Red pushes book down to Blue room pantry
    Util.swap_message(body.number, "Threw recipe book through floor!")
    position = destination.position
    pushed_down = true
    $Audio.play()
    # Change the message (used by Item when red player enters collision)
    message = "Press 'E' to pick up recipe book"
  elif !item_collected:
    # Blue picks up the book from the pantry
    Util.swap_message(body.number, collected)
    body.collect_tool("Recipe")
    item_collected = true
    $Sprite.visible = false
