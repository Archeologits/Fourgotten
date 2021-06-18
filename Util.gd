extends Node

var current_scene = null
var player : int
var messages : Dictionary # Should this be an array of arrays?
var inventory : Dictionary
var base_message : String = "Press 1 for blue, 2 for red, 3 for green"

func shake():
  current_scene.screen_shake()

func get_player():
  return current_scene.players[current_scene.active_player - 1]

#===============================================================================
# Popup messages
#===============================================================================

func set_message_stacks(player_count : int) -> void:
  # We are using arrays as stacks
  for i in range(player_count):
    messages[i] = [base_message]

func push_message(player_number : int, new_message : String) -> void:
  messages[player_number].push_back(new_message)
  _update_message()

func pop_message(player_number : int) -> void:
  if !messages[player_number].empty():
    messages[player_number].pop_back()
    _update_message()

func swap_message(player_number : int, new_message : String) -> void:
  if !messages[player_number].empty():
    messages[player_number][-1] = new_message
    _update_message()

func swap_base_message(new_message : String) -> void:
  base_message = new_message
  for player_number in messages.keys():
    messages[player_number][0] = base_message

func _update_message() -> void:
  if !messages[player].empty():
    current_scene.get_node("HUD/Popup/Label").text = messages[player].back()

#===============================================================================
# Inventory
#===============================================================================

func update_inventory() -> void:
  inventory.clear()
#  for child in current_scene.get_node("HUD/Inventory"):
#    child.queue_free()
  for tool_name in Util.get_player().tools:
    push_tool(player, tool_name)

func push_tool(player_number : int, tool_name : String) -> void:
  print("oi")
  var loaded = load("res://tool_images/" + tool_name + ".png")
  if loaded == null:
    return
  var img = loaded.get_data()
  img.resize(32, 32)
  var tex = ImageTexture.new()
  tex.create_from_image(img)
  var spr = TextureRect.new()
  spr.texture = img
  current_scene.get_node("HUD/Inventory").add_child(spr)
  inventory[tool_name] = spr

func erase_tool(player_number : int, tool_name : String) -> void:
  var spr = inventory.get(tool_name)
  if spr == null:
    return
  current_scene.get_node("HUD/Inventory").remove_child(spr)
  inventory.erase(spr)
