extends Node2D

# Member variables
export var max_candle_count : int = 2
onready var room = get_parent()

var candle_count : int = 0
var item_collected : bool = false
var interactible : bool = true
var last_player : Player

func _ready():
  $Collision.disabled = true
  $Sprite.visible = false
  for i in range(1, max_candle_count + 1):
    var candle = room.get_node("Candle" + str(i))
    candle.connect("candle_on", self, "_on_candle_on")
    candle.connect("candle_off", self, "_on_candle_off")    

func interact(body : Player) -> void:
  Util.swap_message("Found rotten meat!!")
  body.collect_tool("Rotten meat")
  item_collected = true

func _on_candle_on() -> void:
  candle_count += 1
  if candle_count == max_candle_count:
    $Collision.disabled = false
    $Sprite.visible = true

func _on_candle_off() -> void:
  candle_count -= 1

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
      queue_free()
