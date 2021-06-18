extends Area2D
class_name Item

# Member variables
export (String) var item_name : String = "Item"
export (String) var tool_name : String = ""
export (String) var message : String = "Press 'E' to interact"
export (String) var collected : String = "Found a "

var item_collected : bool = false
var interactible : bool = true
var last_player : Player

func _ready() -> void:
  connect("body_entered", self, "_on_player_entered")
  connect("body_exited", self, "_on_player_exited")

func interact(body : Player) -> void:
  if !item_collected and tool_name != "":
    Util.swap_message(body.number, collected)
    body.collect_tool(tool_name)
    item_collected = true
  else:
    Util.swap_message(body.number, "...")
    Util.shake()

func _on_player_entered(body : Node2D) -> void:
  if !item_collected and body.is_in_group("Players"):
    Util.push_message(body.number, message)
    body.interactible = self
    last_player = body

func _on_player_exited(body : Node2D) -> void:
  if interactible and body.is_in_group("Players"):
    Util.pop_message(body.number)
    body.interactible = null
    if item_collected:
      queue_free()
