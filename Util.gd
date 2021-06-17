extends Node

var current_scene = null
var player : int
var messages : Dictionary

func set_message_stacks(player_count : int) -> void:
  for i in range(1, player_count+1):
    messages[i] = ["Press 1 for blue, 2 for red, 3 for green"]

func push_message(text : String) -> void:
  messages[player].push_back(text)
  _update_message()

func get_player():
  return current_scene.players[current_scene.active_player - 1]

func swap_message(text : String) -> void:
  if !messages[player].empty():
    messages[player][-1] = text
    _update_message()

func pop_message() -> void:
  messages[player].pop_back()
  _update_message()

func _update_message() -> void:
  if !messages[player].empty():
    current_scene.get_node("Popup/Popup/Label").text = messages[player].back()

func shake():
  current_scene.screen_shake()
