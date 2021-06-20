extends Node

func _ready():
  Util.hud = $HUD
  Util.game = $World/Viewport/Game
  Util.game.start()
  Util.hud.start($World/Viewport.world_2d, Util.game)
  Util.game.switch_to_player(0)
