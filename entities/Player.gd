extends KinematicBody2D
class_name Player

# Member variables
export (String) var id : String = ""
export (int, 0, 2) var number : int = 0
export (int, 0, 2000) var speed : int = 400
export (int, 0, 4000) var acceleration : int = 2000
export (int, 0, 100) var max_health : int = 100
export (bool) var current : bool = true

var body : AnimatedSprite
var static_image : Sprite
var audio : AudioStreamPlayer2D

var facing : Vector2 = Vector2.RIGHT
var direction : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2.ZERO
var weird_food_counter : int = 0
var interactible = null
var tools : Array

signal merge(Player, Player)

func _enter_tree():
  # These need to be assigned as soon as player enters tree for FSM to work
  # https://kidscancode.org/godot_recipes/basics/tree_ready_order/
  body = get_node("Body")
  static_image = get_node("StaticImage")
  audio = get_node("Audio")

func collect_tool(tool_name : String) -> void:
  tools.push_back(tool_name)
  Util.push_tool(tool_name)
  if ["Burnt bread", "Rotten meat", "Wine"].has(tool_name):
    weird_food_counter += 1
    if weird_food_counter == 3:
      weird_food_counter = 0 # This is a safety precaution
      $Timer.start()
      yield($Timer, "timeout")
      Util.push_message(number, "Made weird food")
      erase_tool("Burnt bread")
      erase_tool("Rotten meat")
      erase_tool("Wine")
      collect_tool("Weird food")
      Util.update_inventory()
      $Timer.start()
      yield($Timer, "timeout")
      Util.pop_message(number)

func erase_tool(tool_name : String) -> void:
  tools.erase(tool_name)
  Util.erase_tool(tool_name)

func _process(_delta : float) -> void:
  _handle_input()

func _physics_process(delta : float) -> void:
  _apply_movement(delta)

func _input(event) -> void:
  if current:
    if event.is_action_pressed("interact") and interactible != null:
      interactible.interact(self)

func _handle_input() -> void:
  if current:
    direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
    direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
    if direction.x != 0:
      direction.y = 0
    if direction != Vector2.ZERO:
      facing = direction
    direction = direction.normalized()

func _apply_movement(delta : float) -> void:
  velocity = velocity.move_toward(direction*speed, acceleration*delta)
  velocity = move_and_slide(velocity)

func _on_Interaction_body_entered(body : Node2D) -> void:
  if body.is_in_group("Players"):
    emit_signal("merge", self, body)
