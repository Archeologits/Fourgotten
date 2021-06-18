extends Item

# Member variables
var state : String = "off"

signal candle_on()
signal candle_off()

func interact(body : Player) -> void:
  if body.tools.has("Lighter"):
    _switch_state()
  else:
    Util.swap_message(body.number, "...")
    Util.shake()

func _switch_state() -> void:
  state = "on" if state == "off" else "off"
  $Sprite.play(state)
  if state == "on":
    $Audio.play()
    $Light.enabled = true
    $Animation.play("pulsate")
    emit_signal("candle_on")
  else:
    $Animation.stop()
    $Light.enabled = false
    emit_signal("candle_off")

func _on_player_exited(body : Node2D) -> void:
  if body == last_player:
    Util.pop_message(body.number)
    body.interactible = null
