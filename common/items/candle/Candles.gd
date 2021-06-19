extends Item

# Member variables
var state : String = "off"

signal candle_on(player)
signal candle_off(player)

func interact(body : Player) -> void:
  if body.tools.has("Lighter"):
    _switch_state(body)
  else:
    Util.swap_message(body.number, "...")
    Util.shake()

func _switch_state(body : Player) -> void:
  state = "on" if state == "off" else "off"
  $Sprite.play(state)
  if state == "on":
    $Audio.play()
    $Light.enabled = true
    $Animation.play("pulsate")
    emit_signal("candle_on", body)
  else:
    $Animation.stop()
    $Light.enabled = false
    emit_signal("candle_off", body)

func _on_player_exited(body : Node2D) -> void:
  if body == last_player:
    Util.pop_message(body.number)
    body.interactible = null
