extends Area2D
class_name RecipeBook

# Member variables
export (String) var message : String = "Press 'E' to interact"
onready var destination : Position2D = get_node("../RecipeBookDestination")
var last_player : Player

var pushed_down : bool = false
var item_collected : bool = false

func interact(body : Player) -> void:
  if !pushed_down:
    # Red pushes book down the hole (move book to Blue Room Pantry)
    position = destination.position
    pushed_down = true
  elif !item_collected:
    # Blue picks up the book from the pantry
    body.collect_tool("Recipe")
    Util.swap_message("Found recipe: 'Bread, Meat, Wine'")
    item_collected = true
    $Sprite.visible = false
  
func _on_player_entered(body : Node2D) -> void:
  if body.is_in_group("Players"):
    Util.push_message(message)
    body.interactible = self
    last_player = body

func _on_player_exited(body : Node2D) -> void:
  if body == last_player:
    Util.pop_message()
    body.interactible = null
    if item_collected:
      queue_free()
