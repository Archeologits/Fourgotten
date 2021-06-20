extends Node

var game = null
var hud = null

func shake():
  game.screen_shake()

func get_player():
  return game.players[Globals.player]

func merge_players(a : int, b : int, c : Player) -> void:
  hud.merge_players(a, b, c)

#===============================================================================
# Popup messages
#===============================================================================

func set_message_stacks(player_count : int) -> void:
  hud.set_message_stacks(player_count)

func push_message(player_number : int, new_message : String) -> void:
  hud.push_message(player_number, new_message)

func pop_message(player_number : int) -> void:
  hud.pop_message(player_number)

func swap_message(player_number : int, new_message : String) -> void:
  hud.swap_message(player_number, new_message)

func swap_base_message(new_message : String) -> void:
  hud.swap_base_message(new_message)

func update_message() -> void:
  hud._update_message()

#===============================================================================
# Inventory
#===============================================================================

func push_tool(tool_name : String) -> void:
  hud.push_tool(tool_name)

func erase_tool(tool_name : String) -> void:
  hud.erase_tool(tool_name)

func update_inventory() -> void:
  hud.update_inventory()
