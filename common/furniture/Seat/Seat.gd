extends Furniture

# Member variables
var connected_to_player : bool = false
var chair_under_crow : bool = false
var distance_to_player : Vector2

func _physics_process(delta : float) -> void:
  if connected_to_player:
    position = last_player.position + distance_to_player

func interact(body : Player) -> void:
  # Item moves with player
  connected_to_player = !connected_to_player # toggle connection
  if chair_under_crow and tool_name == "Quill":
    Util.swap_message(body.number, "Found quill!!")
    body.collect_tool("Quill")
    tool_name = ""
  elif connected_to_player: # Inherit the chair's collision shape
    last_player = body
    distance_to_player = position - body.position

#    var new_collision = CollisionShape2D.new()
#    new_collision.name = "ChairCollision"
#    new_collision.shape = $ChairCollision.shape
#    new_collision.position = $pos.global_position
  
#    var chair_collision = $ChairCollision
#    remove_child(chair_collision)
#    chair_collision.position = $pos.global_position
#    body.add_child(chair_collision)

#    body.add_child(new_collision)
    $ChairCollision.disabled = true

  else: # Return the collision shape to the chair
#    var chair_collision = body.get_node("ChairCollision")
#    body.remove_child(chair_collision)

#    chair_collision.position = $pos.position
#    add_child(chair_collision)

    $ChairCollision.disabled = false

func _on_crow_entered(body : Node2D) -> void:
  if body.name == "Crow" and tool_name == "Quill":
    Util.swap_message(body.number, "Collect quill? (E)")
    chair_under_crow = true

func _on_crow_exited(body : Node2D) -> void:
  if body.name == "Crow":
    Util.swap_message(body.number, message)
    chair_under_crow = false
