extends Item

# Member variables
export var max_candle_count : int = 2
onready var room = get_parent()

var candle_count : int = 0

func _ready():
  $Collision.disabled = true
  $Sprite.visible = false
  for i in range(1, max_candle_count + 1):
    var candle = room.get_node("Candle" + str(i))
    candle.connect("candle_on", self, "_on_candle_on")
    candle.connect("candle_off", self, "_on_candle_off")    

func _on_candle_on(_player : Player) -> void:
  candle_count += 1
  if candle_count == max_candle_count:
    $Collision.disabled = false
    $Sprite.visible = true

func _on_candle_off() -> void:
  candle_count -= 1
