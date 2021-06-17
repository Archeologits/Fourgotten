extends Area2D

var red_key_sent : bool = false
var red_key_received : bool = false
var last_player : Player

func activate() -> void:
  $Collision.disabled = false
  $Light.enabled = true

func interact(body : Player) -> void:
  if !red_key_sent and body.tools.has("Red key"):
    Util.swap_message("Threw red key through roof!")
    body.tools.erase("Red key")
    # Soo soo hacky
    red_key_sent = true
    $Collision.disabled = true
    $Light.enabled = true
    $RedKey.visible = true
    $RedKey/Collision.disabled = false
  elif red_key_sent:
    Util.swap_message("Found a red key!!")
    body.collect_tool("Red key")
    red_key_received = true
    $RedKey.visible = false
  else:
    Util.swap_message("...")
    Util.shake()

func _on_player_entered(body : Node2D) -> void:
  if body.is_in_group("Players"):
    Util.push_message("Press 'E' to throw red key")
    body.interactible = self
    last_player = body

func _on_player_exited(body : Node2D) -> void:
  if body == last_player:
    Util.pop_message()
    body.interactible = null

func _on_RedKey_body_entered(body):
  if red_key_sent and body.is_in_group("Players"):
    Util.push_message("Press 'E' to pick up red key")
    body.interactible = self
    last_player = body

func _on_RedKey_body_exited(body):
  if body == last_player:
    Util.pop_message()
    body.interactible = null
    if red_key_received:
      queue_free()
