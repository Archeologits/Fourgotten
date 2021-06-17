extends Area2D
class_name FoodBowl

var item_collected : bool = false
var interactible : bool = true
var last_player : Player

func interact(body : Player) -> void:
  if body.tools.has("Weird food"):
    Util.swap_message("Found green key!!")
    body.tools.erase("Weird food")
    body.collect_tool("Green key")
    item_collected = true
  else:
    Util.swap_message("...")
    Util.shake()

func _on_player_entered(body : Node2D) -> void:
  if !item_collected and body.is_in_group("Players"):
    Util.push_message("Press 'E' to interact")
    body.interactible = self
    last_player = body

func _on_player_exited(body : Node2D) -> void:
  if interactible and body == last_player:
    Util.pop_message()
    body.interactible = null
    if item_collected:
      interactible = false
