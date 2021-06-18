extends Node

var current_scene = null
var player : int
var messages : Dictionary
var base_message : String = "Press 1 for blue, 2 for red, 3 for green"

func get_player():
  return current_scene.players[current_scene.active_player - 1]

func set_message_stacks(player_count : int) -> void:
  # We are using arrays as stacks
  for i in range(player_count):
    messages[i] = [base_message]

func push_message(player_number : int, text : String) -> void:
  messages[player_number].push_back(text)
  _update_message()

func pop_message(player_number : int) -> void:
  messages[player_number].pop_back()
  _update_message()

func swap_message(player_number : int, text : String) -> void:
  if !messages[player_number].empty():
    messages[player_number][-1] = text
    _update_message()

func swap_base_message(text : String) -> void:
  base_message = text
  for player_number in messages.keys():
    messages[player_number][0] = base_message

func _update_message() -> void:
  if !messages[player].empty():
    current_scene.get_node("Popup/Popup/Label").text = messages[player].back()

func shake():
  current_scene.screen_shake()
