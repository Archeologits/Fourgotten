extends Node2D
class_name Furniture

# Member variables
export (String) var furniture_name : String = "Furniture"
export (String) var tool_name : String = ""
export (String) var message : String = "Press 'E' to interact"
export (String) var collected : String = "Found a "
onready var interact : Area2D = $Interact

var item_collected : bool = false
var interactible : bool = true
var last_player : Player

func _ready() -> void:
  interact.connect("body_entered", self, "_on_player_entered")
  interact.connect("body_exited", self, "_on_player_exited")

func interact(body : Player) -> void:
  if !item_collected and tool_name != "":
    Util.swap_message(collected)
    body.collect_tool(tool_name)
    item_collected = true
  else:
    Util.shake()

func _on_player_entered(body : Node2D) -> void:
  if !item_collected and body.is_in_group("Players"):
    Util.push_message(message)
    body.interactible = self
    last_player = body

func _on_player_exited(body : Node2D) -> void:
  if interactible and body == last_player:
    Util.pop_message()
    body.interactible = null
    if item_collected:
      interactible = false
