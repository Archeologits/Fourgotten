extends Area2D
class_name Candle

# Member variables
export (String) var message : String = "Press 'E' to interact"
onready var animation : AnimationPlayer = $Animation

var last_player : Player
var state : String = "off"

signal candle_on()
signal candle_off()

func interact(body : Player) -> void:
  if body.tools.has("Lighter"):
    _switch_state()
  else:
    Util.shake()

func _switch_state() -> void:
  state = "on" if state == "off" else "off"
  $Sprite.play(state)
  if state == "on":
    Sounds.play("candle_light")
    $Light.enabled = true
    animation.play("pulsate")
    emit_signal("candle_on")
  else:
    animation.stop()
    $Light.enabled = false
    emit_signal("candle_off")

func _on_player_entered(body : Node2D) -> void:
  if body.is_in_group("Players"):
    Util.push_message(message)
    body.interactible = self
    last_player = body

func _on_player_exited(body : Node2D) -> void:
  if body == last_player:
    Util.pop_message()
    body.interactible = null
