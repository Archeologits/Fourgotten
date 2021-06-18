extends AnimatedSprite
class_name Door

# Member variables
export (String) var door_name : String = "Door"
export (String) var key_name : String = ""
export (String) var message : String = "Press 'E' to interact"
export (String) var closed : String = "Can't open"
export (String) var opened : String = "Door opened!!"

var interactible : bool = true
var door_opened : bool = false
var last_player : Player

signal opened()

func _ready() -> void:
  $Interact.connect("body_entered", self, "_on_player_entered")
  $Interact.connect("body_exited", self, "_on_player_exited")

func interact(body : Player) -> void:
  if !door_opened and (key_name == "" or body.tools.has(key_name)):
    # Play opening animation and remove collisions/interaction shapes
    Util.swap_message(body.number, opened)
    door_opened = true
    $Collision.queue_free()
    $Interact.queue_free()
    $Audio.play()
    play("open")
    emit_signal("opened")
  else:
    Util.swap_message(body.number, closed)    
    Util.shake()

func _on_player_entered(body : Node2D) -> void:
  if !door_opened and body.is_in_group("Players"):
    Util.push_message(body.number, message)
    body.interactible = self
    last_player = body

func _on_player_exited(body : Node2D) -> void:
  if interactible and body == last_player:
    Util.pop_message(body.number)
    body.interactible = null
    if door_opened:
      interactible = false
